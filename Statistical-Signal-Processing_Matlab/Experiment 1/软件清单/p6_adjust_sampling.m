

cnt = [];
% ML method
% counting detection rate
ML_detect_suceed = 0;
ML_detect_fail = 0;
ML_false_alarm = 0;
ML_false_dismissal = 0;
ML_p = [];
ML_p_false_alarm = [];
ML_p_false_dismissal = []; 
ML_risk = [];

% sampling period T = 1ms
% timeline
t = 0:1:301;
% test 100 times
for i = 1:1:100
    
    % swept-frequency cosine, the target signal
    s = chirp(t,0,301,250);
    % white noise
    n_mean = 0; n_var = 25;
    n = n_mean+sqrt(n_var)*randn(1,length(t));

    % probability of containing s(t) = 0.4
    contain = randn(1,1);
    if contain <= 0.4
        x = s+n; % x(t) contains s(t)
        contain = 1;
    else
        x = n; % x(t) dose not contain s(t)
        contain = 0;
    end
    
    % ML detection
    left_side = dot(s,s)-2*dot(s,x);
    right_side = -2*n_var*log(0.6/0.4);
    if left_side < right_side
        %result = 1
        if contain == 0
            ML_detect_fail = ML_detect_fail+1;
            ML_false_alarm = ML_false_alarm+1;
        elseif contain == 1
            ML_detect_suceed = ML_detect_suceed+1;
        end
        %disp('s(t) is detected');
    else
        %result = 0
        if contain == 0
            ML_detect_suceed = ML_detect_suceed+1;
        elseif contain == 1
            ML_detect_fail = ML_detect_fail+1;
            ML_false_dismissal = ML_false_dismissal+1;
        end
        %disp('x(t) does not contain s(t)');
    end
    
    cnt = [cnt,i];
    
    fprintf('test %d\n',cnt(i));
    ML_p = [ML_p,ML_detect_suceed/(ML_detect_suceed+ML_detect_fail)];
    ML_p_false_alarm = [ML_p_false_alarm,ML_false_alarm/(ML_detect_suceed+ML_detect_fail)];
    ML_p_false_dismissal = [ML_p_false_dismissal,ML_false_dismissal/(ML_detect_suceed+ML_detect_fail)];
    ML_risk = [ML_risk,0+2*ML_p_false_alarm(i)+ML_p_false_dismissal(i)+0];
    fprintf('ML   : detection rate:%f%%, ',ML_p(i)*100);
    fprintf('false alarm rate:%f%%, false dismissal rate:%f%%, ',ML_p_false_alarm(i)*100, ML_p_false_dismissal(i)*100);
    fprintf('risk:%f\n',ML_risk(i));
end

figure(1);
subplot(4,2,1);plot(cnt,ML_p*100);title(strcat('ML detection rate,',num2str(ML_p(100)*100),'%'));ylabel('%');
subplot(4,2,3);plot(cnt,ML_p_false_alarm*100);title(strcat('ML false alarm rate,',num2str(ML_p_false_alarm(100)*100),'%'));ylabel('%');
subplot(4,2,5);plot(cnt,ML_p_false_dismissal*100);title(strcat('ML false dismissal rate,',num2str(ML_p_false_dismissal(100)*100),'%'));ylabel('%');
subplot(4,2,7);plot(cnt,ML_risk);title('ML risk');xlabel('sampling period T = 1ms');

cnt = [];
% ML method
% counting detection rate
ML_detect_suceed = 0;
ML_detect_fail = 0;
ML_false_alarm = 0;
ML_false_dismissal = 0;
ML_p = [];
ML_p_false_alarm = [];
ML_p_false_dismissal = []; 
ML_risk = [];

% sampling period T = 0.5ms
% timeline
t = 0:0.5:301;
% test 100 times
for i = 1:1:100
    
    % swept-frequency cosine, the target signal
    s = chirp(t,0,301,250);
    % white noise
    n_mean = 0; n_var = 25;
    n = n_mean+sqrt(n_var)*randn(1,length(t));

    % probability of containing s(t) = 0.4
    contain = randn(1,1);
    if contain <= 0.4
        x = s+n; % x(t) contains s(t)
        contain = 1;
    else
        x = n; % x(t) dose not contain s(t)
        contain = 0;
    end
    
    % ML detection
    left_side = dot(s,s)-2*dot(s,x);
    right_side = -2*n_var*log(0.6/0.4);
    if left_side < right_side
        %result = 1
        if contain == 0
            ML_detect_fail = ML_detect_fail+1;
            ML_false_alarm = ML_false_alarm+1;
        elseif contain == 1
            ML_detect_suceed = ML_detect_suceed+1;
        end
        %disp('s(t) is detected');
    else
        %result = 0
        if contain == 0
            ML_detect_suceed = ML_detect_suceed+1;
        elseif contain == 1
            ML_detect_fail = ML_detect_fail+1;
            ML_false_dismissal = ML_false_dismissal+1;
        end
        %disp('x(t) does not contain s(t)');
    end
    
    cnt = [cnt,i];
    
    fprintf('test %d\n',cnt(i));
    ML_p = [ML_p,ML_detect_suceed/(ML_detect_suceed+ML_detect_fail)];
    ML_p_false_alarm = [ML_p_false_alarm,ML_false_alarm/(ML_detect_suceed+ML_detect_fail)];
    ML_p_false_dismissal = [ML_p_false_dismissal,ML_false_dismissal/(ML_detect_suceed+ML_detect_fail)];
    ML_risk = [ML_risk,0+2*ML_p_false_alarm(i)+ML_p_false_dismissal(i)+0];
    fprintf('ML   : detection rate:%f%%, ',ML_p(i)*100);
    fprintf('false alarm rate:%f%%, false dismissal rate:%f%%, ',ML_p_false_alarm(i)*100, ML_p_false_dismissal(i)*100);
    fprintf('risk:%f\n',ML_risk(i));
end

figure(1);
subplot(4,2,2);plot(cnt,ML_p*100);title(strcat('ML detection rate,',num2str(ML_p(100)*100),'%'));ylabel('%');
subplot(4,2,4);plot(cnt,ML_p_false_alarm*100);title(strcat('ML false alarm rate,',num2str(ML_p_false_alarm(100)*100),'%'));ylabel('%');
subplot(4,2,6);plot(cnt,ML_p_false_dismissal*100);title(strcat('ML false dismissal rate,',num2str(ML_p_false_dismissal(100)*100),'%'));ylabel('%');
subplot(4,2,8);plot(cnt,ML_risk);title('ML risk');xlabel('sampling period T = 0.5ms');


