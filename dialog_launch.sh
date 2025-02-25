#報修系統

#報修系統 - yesno : enter or leave
dialog --title "報修系統" --yesno "進入系統請按 Yes；離開請按 No" 5 33
choice=$?

case $choice in
    1)
        dialog --title "Sys info" --msgbox "感謝您的使用" 10 35
        sleep 5;;
    0)
        #報修日期 - calendar : 選擇報修日期
        current_year=$(date +"%Y")
        current_month=$(date +"%-m")
        current_day=$(date +"%d")
        dialog --calendar "請點選報修日期" 4 50 $current_day $current_month $current_year 2> choice.txt;
        echo "報修日期: $(cat choice.txt)" >> temp_report.txt
        
        #報修地點 - menu : 1.建國校區 2.大安分部 3.忠孝校區 4.延平校區
        dialog --title "報修校區" --menu 10 50 4 1 "建國校區" 2 "大安分部" 3 "忠孝校區" 4 "延平校區" 2> choice.txt
        choice=$(cat choice.txt)
        case $choice in
            1)
                echo "報修校區:建國校區" >> temp_report.txt ;;
            2)
                echo "報修校區:大安分部" >> temp_report.txt ;;
            3)
                echo "報修校區:忠孝校區" >> temp_report.txt ;;
            4)
                echo "報修校區:延平校區" >> temp_report.txt ;;
        esac

        #報修種類 - checklist : 1.場地 2.硬體 3.消耗品 4.其他
        dialog --title "報修種類" --checklist "種類可複選" 15 50 4 1 "場地" off 2 "硬體" off 3 "消耗品" off 4 "其他" off 2> choice.txt;
        choices=$(cat choice.txt)
        result=""
        for i in $choices; do
            case $i in
            1)
                result+="場地, ";;
            2)
                result+="硬體, ";;
            3)
                result+="消耗品, ";;
            4)
                result+="其他, ";;
            esac;
        done;
        echo "報修種類: $result" >> temp_report.txt;

        #報修描述 - form : 1.class_name 2.stu_name 3.where 4.description -> 寫入temp_report.txt
        dialog --stdout --title "報修表單" --form "請描述需報修物品" 10 100 4 "報修人:" 1 1 "" 1 15 100 0 "班級:" 2 1 "" 2 15 100 0 "地點代號:" 3 1 "" 3 15 100 0 "報修物描述:" 4 1 "" 4 15 100 0 > form.txt;
        line1=$(cat form.txt | sed -n "1p")
        line2=$(cat form.txt | sed -n "2p")
        line3=$(cat form.txt | sed -n "3p")
        line4=$(cat form.txt | sed -n "4p")
        echo "報修人: $line1" >> temp_report.txt
        echo "班級: $line2" >> temp_report.txt
        echo "地點代號: $line3" >> temp_report.txt
        echo "報修物描述: $line4" >> temp_report.txt
        rm form.txt
        #報修確認 - yesno : content: cat temp_report.txt ; choice: submit or cancel 
        #                   -> 寫入fix_report.txt + 刪除temp_report.txt
        dialog --title "是否確認送出報修單:" --yesno "$(cat temp_report.txt)" 10 50
        choice=$?
        #報修遞交 - msgbox : success message
        case $choice in
            1)
                dialog --title "Sys info" --msgbox "已成功取消送出" 10 50;
                rm temp_report.txt choice.txt;
                sleep 5;;
            0)
                dialog --title "Sys info" --msgbox "已成功送出表單" 10 50;
                cat temp_report.txt >> user_report.txt;
                rm temp_report.txt choice.txt;
                sleep 3;;
        esac
        ;;
esac