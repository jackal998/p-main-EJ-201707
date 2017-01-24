require 'tk'
require 'tkextlib/bwidget'
require 'rubyXL'
require 'csv'
require 'byebug'
require_relative 'helpers/application_helper'
require_relative 'helpers/window_helper'
require_relative 'helpers/converter_helper'


def main_window
  include ApplicationHelper
  include WindowHelper
  include ConverterHelper
    
  root = TkRoot.new { title "鮮乳坊小工具" }

  button_click = Proc.new { get_open_file_call_back(Tk.getOpenFile, root) }
  set_button(root, button_click, "開啟檔案")
  
  Tk.mainloop
end

main_window