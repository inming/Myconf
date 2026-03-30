" === 基础设置 ===
set nocompatible              " 关闭 vi 兼容模式
set encoding=utf-8            " UTF-8 编码
set fileencodings=utf-8,gbk   " 文件编码检测

" === 显示 ===
set number                    " 显示绝对行号
set cursorline                " 高亮当前行
set showmatch                 " 高亮匹配括号
set scrolloff=5               " 光标距顶/底部保留 5 行
set laststatus=2              " 始终显示状态栏
set ruler                     " 状态栏显示光标位置
set showcmd                   " 显示输入的命令

" === 主题与颜色 ===
syntax on                     " 语法高亮
set background=dark           " 深色背景
colorscheme desert            " 内置主题，无需安装插件

" === 搜索 ===
set hlsearch                  " 高亮搜索结果
set incsearch                 " 输入时实时搜索
set ignorecase                " 搜索忽略大小写
set smartcase                 " 有大写字母时区分大小写

" === 缩进 ===
set autoindent                " 自动缩进
set smartindent               " 智能缩进
set tabstop=4                 " Tab 显示为 4 空格
set shiftwidth=4              " 缩进宽度 4
set expandtab                 " Tab 转空格
set softtabstop=4             " 退格删除 4 空格

" === 编辑体验 ===
set backspace=indent,eol,start " 退格键正常工作
set wildmenu                  " 命令行补全菜单
set wildmode=longest:full,full " 补全模式
set mouse=a                   " 启用鼠标
set clipboard=unnamed         " 与系统剪贴板共享

" === 性能 ===
set lazyredraw                " 宏执行时不重绘
set ttyfast                   " 快速终端连接

" === 文件 ===
set nobackup                  " 不生成备份文件
set noswapfile                " 不生成 swap 文件
set autoread                  " 文件外部修改后自动加载

" === 按键映射 ===
" 空格作为 Leader 键
let mapleader=" "
" Leader+h 取消搜索高亮
nnoremap <Leader>h :nohlsearch<CR>
