unit uConfigItemTypes;

interface

type
  // 配置项类型枚举
  TConfigItemType = (
    citText,        // 文本配置项
    citDirectory,   // 目录配置项
    citFile,        // 文件配置项
    citInput,       // 输入配置项
    citFont,        // 字体配置项
    citFontEffect,  // 字体特效配置项
    citImage,       // 图像配置项
    citImageDrawer  // 图像绘制器配置项
  );
  
  // 项目类型枚举
  TProjectType = (
    ptDefault,      // 默认项目类型
    ptTextEditor,   // 文本编辑器项目
    ptImageViewer,  // 图像查看器项目
    ptConfigTool    // 配置工具项目
  );

const
  // 项目类型字符串常量
  PROJECT_TYPE_DEFAULT = 'Default';
  PROJECT_TYPE_TEXT_EDITOR = 'TextEditor';
  PROJECT_TYPE_IMAGE_VIEWER = 'ImageViewer';
  PROJECT_TYPE_CONFIG_TOOL = 'ConfigTool';

implementation

end.