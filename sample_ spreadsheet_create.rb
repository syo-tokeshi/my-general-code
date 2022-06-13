# こちらのシートに書き込む
# https://docs.google.com/spreadsheets/d/xxx/edit#gid=0
require 'google_drive'
require 'active_support/time' # active_supportのtimeクラスを使用 https://qiita.com/shu_0115/items/b490bd3de6bc4d5e43a5

# gauth_config = "#{Rails.root.to_s}/lib/gauth/config.json"
gauth_config = "./config.json"
session = GoogleDrive::Session.from_config(gauth_config) # google認証突破

# シートを新しく作成するために使用
current_spreadsheet = session.spreadsheet_by_key('xxx')

# 現在のシートを取得
current_worksheet = session.spreadsheet_by_key('xxx')
                           .worksheets[0]

# 今月の最終日を表示
p  current_month_last_day = Date.today.end_of_month.day
# p  Date.today

# スプレッドシートへの書き込み
today_date = Time.new
today_date = today_date.strftime("%Y/%m/%d") #見やすいように整形

# 今月の最終日だったら、新しいシートを作り、そこに書き込む
if current_worksheet.num_rows == current_month_last_day
   
   # 来月のシートを作成するために
   next_month = Date.today.month + 1
   # 新しいシートを作成
   current_spreadsheet.add_worksheet("#{next_month}月分")
   # 作られたシートを取得
   new_sheet = session.spreadsheet_by_key('xxx')
                       .worksheet_by_title("#{next_month}月分")
   
   current_row_count = new_sheet.num_rows
   # puts  "シートの行数は#{current_row_count}です" #  [DEBUG]
   
   # 来月のシートの、一番最初の行に挿入
   new_sheet[1, 1] =  today_date
   new_sheet[1, 2] =  today_date
   # シートの保存
   new_sheet.save
else
    #最終日以外は、現在のシートに、そのまま追加していく
    current_row_count = current_worksheet.num_rows
    puts  "現在のシートの行数は#{current_row_count}です"

    incert_cell_number = current_row_count + 1 # 挿入する行番号
    puts "#{incert_cell_number}行目に新しく挿入しました"
    current_worksheet[incert_cell_number, 1] =  today_date
    current_worksheet[incert_cell_number, 2] =  today_date
    # シートの保存
    current_worksheet.save
end
