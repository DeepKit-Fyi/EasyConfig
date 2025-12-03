# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project overview

**易配 (EasyConfig)** - A universal configuration editor built with Delphi/FMX, using an **INI + JSON dual-file model**:
- **EasyConfig FMX** (`ConfigBuildFMX.dpr/.dproj` + `ViewMainFormFMX.pas`) is the primary cross-platform application for building and validating configuration pairs (INI + JSON).
- **EasyConfig VCL** (`ConfigBuild.dpr/.dproj` + `ViewBuildConfig.pas`) is the legacy VCL version using a grid/tree UI.
- **ConfigEditor** (`ConfigEditor.dpr/.dproj` + `FormMain.pas`) is a more general, MVC-style configuration editor that shares the same underlying storage, type system, and complex-property editors.

Configuration semantics (what goes into INI vs JSON, type naming, and layout) are documented primarily in:
- `dev.md` – high-level design for ConfigEditor.
- `config/config-principles.md` – how config files are located and loaded.
- `config/ini_json_rules.md` – canonical INI/JSON schema, type tags (e.g. `etFont`, `etAIAPI`), and reference rules.
- `attribute.md` – catalog of supported property types and their intended usage.

When changing anything related to config types or file formats, keep these documents and `UtilsTypes.pas` in sync.

## Repository layout (high level)

- **Applications**
  - `ConfigBuild.dpr/.dproj` – main entry for the ViewBuildConfig-based editor.
  - `ConfigEditor.dpr/.dproj` – main entry for the FormMain-based editor that leans more heavily on the MVC design in `dev.md`.
- **Core config model & storage**
  - `BaseConfig.pas` – base `TBaseConfig` with `TJSONConfig`/`TINIConfig` concrete implementations for file-backed configs.
  - `JSONConfig.pas` – higher-level JSON helper class (`TJSONConfig`) with path-like accessors, array/object helpers, ID lookup (`FindObjectByID`), etc.
  - `INIConfig.pas` – legacy INI helpers plus `TINIConfigManager` for bridging INI sections/keys into JSON objects via `TConfigType`.
  - `ConfigManager.pas` – orchestrates a paired INI/JSON config: loads them together, derives the JSON path from INI (`[json_file]/file_path`), and tracks modification state.
- **Type system & helpers**
  - `UtilsTypes.pas` – the **single source of truth** for:
    - `TConfigType` (ctPlain, ctInteger, ctFloat, ctBoolean, ctFont, ctColor, ctDatabase, ctList, ctObject, ctAIAPI, ctArray, ...).
    - `TEditorType` and `TComplexPropertyType` plus mapping functions between them.
    - Helpers like `ConfigTypeToString/StringToConfigType`, `EditorTypeToConfigType`, `GetTypeFromINIKey`, `GetTypeFromJSON`, and color helpers (`StringToColor`, `ColorToHTML`, etc.).
- **Validation**
  - `ConfigValidator.pas` – rule-based validator (`TConfigValidator`, `TValidationRule`) used from the UI; supports many rule kinds (required, numeric, range, length, regex, email, URL, IP, date/time, password, color, unique, JSON/XML, custom), plus optional auto-fix.
  - `ValidationDialog.pas` – dialog to surface validation results.
- **View & controllers (ConfigBuild)**
  - `ViewBuildConfig.pas` – main form (`TFrmBuildConfig`) with:
    - INI grid (`sgINI`) and JSON tree (`tvJSON`), plus synchronized text mappers (`UpdateIniMemo`, `UpdateJsonMemo`).
    - Buttons for adding various simple and complex properties.
    - `FValidator: TConfigValidator` and `InitializeValidator` configuring default validation rules.
    - Integration points for complex property editors via `ControllerConfigs` and `TEditorType/TComplexPropertyType` tags in `UtilsTypes.pas`.
  - `ControllerConfigs.pas` – singleton controller that:
    - Creates default JSON payloads for complex property types (`TComplexPropertyType`).
    - Picks a corresponding frame (`TBaseConfigFrame` descendant) such as `FrameBgDrawEditor`, `FrameVideoClipEditor`, `FrameVideoEditor`, `FrameNetConfigEditor`, `FrameGeoLocationEditor`, `FrameEncryptEditor`, `FrameDateTimeRangeEditor`.
    - Hosts the frame in a parent panel and coordinates load/save of JSON and edit completion callbacks.
- **View & controllers (ConfigEditor)**
  - `FormMain.pas` – main form for the more general editor.
  - `FrameConfigEditor.pas` – generic editor frame implementing `IConfigEditor` (from `ConfigIntf.pas`) for **one INI key + associated JSON object**:
    - Uses `TBaseConfigFrame` descendants to edit complex JSON while mirroring simple values to INI.
  - `ConfigFrameBase.pas` – base visual class `TBaseConfigFrame` for all complex-property editor frames. Expects a `JSONObject` property and `LoadFromJSON/SaveToJSON` overrides.
  - `ConfigEditorsBase.pas` + `ConfigEditors.pas` – non-visual interface/factory for config editors keyed by `TConfigType`.
  - `ModelConfig.pas` + `ModelRegistry.pas` – higher-level abstraction for “config documents” (`IConfigDocument`) and “processors” (`IConfigProcessor`) plus a registry (`TConfigRegistry`). Not all of this is wired up in the current UI yet, but it documents intended layering.
- **Editor frames for complex types**
  - `FrameFontEditor.pas`, `FrameDBEditor.pas`, `FrameListEditor.pas`, `FrameObjectEditor.pas`, `FrameArrayEditor.pas`, `FrameAIAPIEditor.pas`, `FrameBgDrawEditor.pas`, `FrameVideoClipEditor.pas`, `FrameVideoEditor.pas`, `FrameGeoLocationEditor.pas`, `FrameUrlConfigEditor.pas`, `FrameNetConfigEditor.pas`, `FrameEncryptEditor.pas`, `FrameDateTimeRangeEditor.pas`, etc.
  - These typically inherit from `TBaseConfigFrame` and are selected by `ControllerConfigs` based on `TComplexPropertyType`.
- **Third-party / shared library**
  - `IniConfigEditorLib\` – embedded library containing `VirtualTrees.*` units and INI-based editor abstractions. Treat this as vendor code unless you know you need to modify it.
- **Documentation & samples**
  - `DelphiCode.md` – Delphi coding guidelines specific to this repo (design-time first, MVC separation, naming and layout rules).
  - `dev.md` / `progress.md` – design and progress notes for the original ConfigEditor project.
  - `config\config-principles.md`, `config\ini_json_rules.md` – authoritative description of how config files are organized (start.ini logic, config root, INI/JSON division, reference semantics, and editor mappings).
  - `configs\ConfigBuild.json`, `config\*.template-001.json`, `examples\app_config.json` – sample configuration content demonstrating the above rules.
- **Tests & legacy**
  - `backup\` – older test runners, legacy editors, and a full DUnit-based test harness (see below).
  - `tests\` – small console/sample apps (e.g. `SimpleTest.dpr`, `FinalConfigEditor.dpr`, `NewConfigEditor.dpr`) used as experimental drivers.

## Build & run commands

These commands assume a Windows environment with a suitable Delphi toolchain installed and either `dcc32` or Delphi’s MSBuild on `PATH`.

### Build & run ConfigBuild (ViewBuildConfig-based app)

**Using the Delphi compiler directly (simplest):**

```bat
:: From the repo root
dcc32 ConfigBuild.dpr
ConfigBuild.exe
```

**Using MSBuild and the .dproj (honors project configurations):**

```bat
:: Debug Win32 build
msbuild .\ConfigBuild.dproj /p:Config=Debug /p:Platform=Win32
.\nWin32\Debug\ConfigBuild.exe
```

### Build & run ConfigEditor (FormMain-based app)

```bat
:: Build and run the more general ConfigEditor UI
dcc32 ConfigEditor.dpr
ConfigEditor.exe
```

Both apps target VCL/Win32 by default; `ConfigBuild.dproj` also defines Win64 configurations via MSBuild if your Delphi SKU supports it.

If the compilers are not on `PATH`, open the corresponding `.dproj` in the Delphi IDE and build/run from there.

### Encoding and conversion utilities

A significant portion of the project has been migrated to **UTF-8 (with BOM)**, and `UTF8Converter.pas` / `ConvertFilesToUTF8.dpr` plus `Convert.bat` / `ConvertFiles.bat` exist to help convert older source files.
- When adding or heavily editing Delphi units, keep them in UTF-8 with BOM to avoid mojibake in Chinese comments and strings.

## Test & QA commands

Most structured tests live under `backup\` and use a DUnit-style framework (`TestFramework.pas`, `TextTestRunner.pas`, `GUITestRunner.pas`).

### Run the main configuration test suite

Recommended path (batch script):

```bat
:: From repo root
.
backup\RunTests.bat
```

`RunTests.bat` will:
- Use `%DCC32_PATH%` (defaulting to `dcc32`) to compile `backup\TestRunner.dpr`.
- Run `TestRunner.exe console` to execute all registered tests in console mode.

Manual equivalent:

```bat
:: Compile the DUnit test runner
cd backup

:: Adjust dcc32 path as needed
set DCC32_PATH=dcc32
%DCC32_PATH% TestRunner.dpr

:: Run in console mode (non-empty param triggers TextTestRunner)
TestRunner.exe console
```

The tests exercise `SystemConfigTests`, `UIConfigTests`, `MediaConfigTests`, and related units; see `backup\TestReadme.md` and `backup\TestingFramework.md` for details.

### Run a single, focused test runner

There are several minimal/targeted runners under `backup\`:

```bat
:: Minimal media test runner
cd backup
dcc32 MinimalMediaTestRunner.dpr
MinimalMediaTestRunner.exe

:: Example media-config runner
dcc32 MediaConfigTestExample.dpr
MediaConfigTestExample.exe

:: Basic DUnit example runner
dcc32 BasicTestsRunner.dpr
BasicTestsRunner.exe
```

These act as “single test” or small-suite runners when you only need to exercise a narrow slice of functionality.

## JSONHelpers and compatibility scripts

### JSONHelpers.pas and TJSONObject.AddPair

`README_JSON_FIX.md` explains a compatibility problem: some Delphi versions lack the `TJSONObject.AddPair` overloads commonly used in modern code. The project solves this with `JSONHelpers.pas`, which defines a `TJSONObjectHelper` class helper that adds multiple `AddPair` overloads.

Key rules for new code:
- Any unit that uses `System.JSON.TJSONObject.AddPair` **must** include `JSONHelpers` in its `uses` clause.
- Prefer the helper overloads (`AddPair(Name, string/Boolean/Integer/Double/TJSONValue)`) instead of manually constructing `TJSONPair`.

Automation scripts:
- `fix_addpair_implementation.ps1` – ensures `JSONHelpers.pas` exists and contains the required helper implementations.
- `fix_addpair.ps1` / `check_and_fix_json_units.ps1` – scan all `*.pas` for `System.JSON` usage and auto-add `JSONHelpers` to the `uses` clause when missing.

If you add new JSON-heavy units, mirror the existing pattern: `uses System.JSON, JSONHelpers;` at minimum.

### Other PowerShell fix scripts

The root directory contains many focused PowerShell scripts used historically to patch the Delphi codebase, for example:
- `fix_all_issues.ps1` – rewrites specific lines in `ConfigValidator.pas` (e.g., `TryStrToDateTime` overload usage, `CharInSet` for character set checks, `AddPasswordRule` signature alignment, and inserting `{$WARN IMPLICIT_STRING_CAST OFF}`).
- `fix.ps1` and `comprehensive_fix.ps1` – apply regex-based fixes to `ViewBuildConfig.pas` (adding `JSONHelpers, ConfigValidator` to `uses`, ensuring `FValidator: TConfigValidator` and `InitializeValidator` exist, reconstructing `btnValidate` wiring, fixing missing semicolons and some `ShowMessage`/`SetGridCell` calls).

They’re mainly for one-off upgrades and should **not** be part of normal development flows, but it’s important not to regress the issues they fixed (see `bugfix.md` and `reduceBugs.md` for context).

## Configuration model (INI + JSON)

The central design, described in `dev.md`, `config/config-principles.md`, and `config/ini_json_rules.md`, is:

- Each “configuration unit” is represented by **one INI file paired with one JSON file**.
- **INI file**:
  - Stores simple, flat key/value settings.
  - Contains a `[json_file]` section whose `file_path` key points to the associated JSON file (relative or absolute).
  - Other sections hold simple-typed values; the key name usually encodes the type (e.g., prefixes or `etText.*` conventions, see `UtilsTypes.GetTypeFromINIKey`).
- **JSON file**:
  - Stores complex, structured settings: fonts, backgrounds, AI API configs, video clips, workflows, etc.
  - Complex objects have a `_type` (logical type, like `etFont`, `etDatabase`, `etAIAPI`, `etBgDraw`, `etVideoClip`, `etVideo`) and usually an `_id` used for references.
  - Reference semantics (`_ref` pointing at `_id`) and structural rules (arrays vs objects, metadata like `_description`) are defined in `config/ini_json_rules.md`.
- **ConfigManager / JSONConfig / INIConfigManager** provide the glue:
  - `ConfigManager.pas` keeps an INI and JSON in sync and centralizes load/save paths.
  - `JSONConfig.pas` implements path-based JSON access and ID-based object lookup (`FindObjectByID`).
  - `INIConfig.pas` (`TINIConfigManager`) converts between INI sections/keys and JSON structures based on `TConfigType`.

When you add new configuration concepts (new `_type` values, new property groups, etc.), you must:
- Extend `TConfigType` / `TEditorType` / `TComplexPropertyType` in `UtilsTypes.pas`.
- Update mapping helpers (`EditorTypeToConfigType`, `ComplexPropertyTypeToEditorType`, string conversions).
- Implement or extend the corresponding editor frame and wiring in `ControllerConfigs.pas` and/or `FrameConfigEditor.pas`.
- If the type has special layout rules in INI/JSON, update `config/ini_json_rules.md` and `attribute.md` accordingly.

## UI & controller architecture

There are effectively two UI stacks sharing the same underlying model:

1. **ConfigBuild stack (ViewBuildConfig)**
   - `ConfigBuild.dpr` → `ViewBuildConfig.pas (TFrmBuildConfig)` as main form.
   - INI is shown and edited in a `TStringGrid`; JSON is visualized as a `TTreeView` with `PConfigPropertyItem` payloads.
   - Many button `Tag` values map to `TComplexPropertyType` (see `UtilsTypes.pas` and `attribute.md`).
   - `ControllerConfigs` manages the lifecycle of complex-property frames inside the `pnlEditorContent`/related panels.
   - `ConfigValidator` is instantiated in `InitializeValidator` and used via methods like `ValidateConfig` / `ValidateINIProperty` (currently partially stubbed out; see `bugfix.md` and `progress.md` for what still needs implementing).

2. **ConfigEditor stack (FormMain + FrameConfigEditor)**
   - `ConfigEditor.dpr` → `FormMain.pas (TFrmMain)` as main form.
   - `FrameConfigEditor` is a reusable visual editor implementing `IConfigEditor` (from `ConfigIntf.pas`) that:
     - Receives `IINIConfig` and `IJSONConfig` instances.
     - Creates a `TBaseConfigFrame` for a given `TConfigType`.
     - Handles Save/Cancel and writes values back to both INI and JSON using type-aware logic.
   - `ControllerMain.pas` + `ViewIntf.pas` define a higher-level MVC-style controller and view interfaces; much of `ControllerMain` is still skeletal (many methods are stubs/logging-only), but it documents intended direction.

When implementing new UI features, prefer wiring them through the existing controllers (`ControllerConfigs`, `ConfigManager`, `ConfigValidator`) rather than embedding logic directly into forms.

## Important local conventions & pitfalls

These are the most important repository-specific rules to respect when editing or generating code:

### Coding & structure conventions (DelphiCode.md)

- Prefer **design-time** configuration of VCL components; avoid creating lots of controls dynamically unless necessary (most editing logic should operate on existing controls or frames).
- Keep **forms focused on UI**; business/config logic belongs in controllers (`Controller*` units), models (`Model*`, `Config*`), and helpers (`Helper*`, `Utils*`).
- Centralize **type/constant definitions** in `UtilsTypes.pas` instead of duplicating structures across units.
- Existing code mostly lives flat in the project root; avoid introducing new deep directory hierarchies unless you have a compelling reason.

### Config & type system

- `UtilsTypes.pas` is authoritative for:
  - Config types (`TConfigType`), editor types (`TEditorType`), complex property types (`TComplexPropertyType`).
  - Detection helpers (`GetTypeFromINIKey`, `GetTypeFromJSON`) and groupings (e.g., which types are “simple” vs “complex”).
  - Color conversion helpers and position helper records (e.g., `TPositionInfo`).
- When you introduce new config types or complex-property kinds, **update these enums and mapping functions first**, then wire up frames and controllers.

### JSON & AddPair compatibility

- Always include `JSONHelpers` wherever you use `TJSONObject.AddPair`; do **not** rely on Delphi’s built-in overloads being present.
- Avoid duplicating AddPair-style logic; call the helper methods defined in `JSONHelpers.pas` instead.

### Validation & bug-fix history (bugfix.md, reduceBugs.md)

Common issues that have already been debugged and should not be reintroduced:
- Incorrect `TryStrToDateTime` overload usage and character-set tests in `ConfigValidator.pas` (fixed by `fix_all_issues.ps1`).
- Missing `begin/end` blocks around `for` loops (e.g., in `FrameVideoEditor.pas`), which caused cryptic compiler errors. Stick to full `begin/end` blocks even for single-line loops.
- Improper freeing of `tvJSON` node data in `ViewBuildConfig.ClearAllData` (access violations on shutdown). When manipulating the JSON tree, always ensure `Node.Data` is freed and set to `nil`, and guard with `Assigned(tvJSON)` / `tvJSON.Items.Count > 0` checks.
- Design-time registration (`Register` procedures using `DesignIntf`) must be wrapped in `{$IFDEF DESIGNTIME}` and never called from `initialization` sections of runtime units.
- `ConfigBuild.exe` can be locked while running, leading to `F2039 Could not create output file` during rebuilds; scripts and docs recommend killing any lingering `ConfigBuild` process before compiling.

### Encoding & Chinese text

- Several units and docs contain Chinese comments and strings. The repository now leans toward **UTF-8 with BOM** for source files.
- When generating new Delphi units, prefer UTF-8 and avoid introducing mojibake; if you need to convert existing ANSI/UTF-16 files, use the `UTF8Converter` tool and related scripts instead of ad-hoc conversions.

### Tests & DUnit

- The test harness in `backup\` is **DUnit-based**; when adding tests, follow `backup\TestingFramework.md` and existing examples like `BasicTestsRunner.dpr` and `MediaConfigTestExample.dpr`.
- Register tests via `RegisterTest` in each `*Tests.pas` unit and include them in `TestRunner.dpr`.

## Where to look before making changes

- For **config schema or file format** questions: `config/ini_json_rules.md`, `config/config-principles.md`, `attribute.md`, `examples/app_config.json`, `configs/ConfigBuild.json`.
- For **type/enum-related** changes: `UtilsTypes.pas` and any switch/if logic that branches on `TConfigType`, `TEditorType`, or `TComplexPropertyType` (including `ControllerConfigs`, `FrameConfigEditor`, `ViewBuildConfig`).
- For **validation** behavior: `ConfigValidator.pas` and `ViewBuildConfig.InitializeValidator`.
- For **testing**: `backup/TestReadme.md`, `backup/TestingFramework.md`, `backup/RunTests.bat`, and `backup/TestRunner.dpr`.

Use these as the primary references when guiding future edits so that both ConfigBuild and ConfigEditor stay coherent and consistent with the documented configuration model.
