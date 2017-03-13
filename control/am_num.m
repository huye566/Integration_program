function label_am=am_num(signal_Am,initial_am,am_step)
label_am=1;
initial_am=initial_am*3;%防止数据过限
if signal_Am>initial_am
        label_am=0;
else
        signal_Am=signal_Am+am_step*3;
        while(signal_Am<initial_am)
            signal_Am=signal_Am+am_step*3;
            label_am=label_am+1;
        end
 end