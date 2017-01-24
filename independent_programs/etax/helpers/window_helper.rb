module WindowHelper
  def set_button(root, process, label)
    button = TkButton.new(root) do
      text label
      pack("side" => "left",  "padx"=> "60", "pady"=> "10")
    end
    button.comman = process
  end

  def show_msg(type, content)
    case type
    when 'filetype_incorrect'
      if content.empty?
        msgBox = Tk.messageBox(
        'type'    => "ok",  
        'icon'    => "info", 
        'title'   => "沒有選擇檔案",
        'message' => "沒有選擇檔案"
        )
      else
        msgBox = Tk.messageBox(
        'type'    => "ok",  
        'icon'    => "info", 
        'title'   => "格式錯誤",
        'message' => "格式#{content}不是可以轉換的格式"
        )
      end
    when 'sheet_missing'
      msgBox = Tk.messageBox(
        'type'    => "ok",  
        'icon'    => "info", 
        'title'   => "資料錯誤",
        'message' => "廠商表、銷貨紀錄遺失或是名稱錯誤"
        )
    when 'time_predict'
      msgBox = Tk.messageBox(
        'type'    => "ok",  
        'icon'    => "info", 
        'title'   => "要花點時間喔！",
        'message' => "資料載入中，需時約#{content}秒"
        )
    when 'content'
      msgBox = Tk.messageBox(
        'type'    => "ok",  
        'icon'    => "info", 
        'title'   => "鮮乳坊小工具",
        'message' => content
        )
    when 'col_empty'
      msgBox = Tk.messageBox(
        'type'    => "ok",  
        'icon'    => "info", 
        'title'   => "鮮乳坊小工具",
        'message' => "店家#{content[0].to_s}的#{content[1].to_s}是空的。"
        )
    else
    end
  end
end
