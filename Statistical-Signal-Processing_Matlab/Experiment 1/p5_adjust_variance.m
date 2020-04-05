MLChange_p = [];
MLChange_p_false_alarm = [];
MLChange_p_false_dismissal = []; 
MLChange_risk = [];
BayesChange_p = [];
BayesChange_p_false_alarm = [];
BayesChange_p_false_dismissal = []; 
BayesChange_risk = [];
% adjust threshold
for PH0 = [0.3,0.4,0.5,0.6,0.7]
    PH1 = 1-PH0;
    
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
    % Bayes method
    % counting detection rate
    Bayes_detect_suceed = 0;
    Bayes_detect_fail = 0;
    Bayes_false_alarm = 0;
    Bayes_false_dismissal = 0;
    Bayes_p = [];
    Bayes_p_false_alarm = [];
    Bayes_p_false_dismissal = []; 
    Bayes_risk = [];
    % test 100 times
    for i = 1:1:100

        % timeline
        t = 0:1:301;
        % swept-frequency cosine, the target signal
        s = chirp(t,0,301,250);
        % white noise
        n_mean = 0; n_var = 25;
        n = n_mean+sqrt(n_var)*randn(1,length(t));

        % probability of containing s(t) = 0.4
        contain = randn(1,1);
        if contain <= PH1
            x = s+n; % x(t) contains s(t)
            contain = 1;
        else
            x = n; % x(t) dose not contain s(t)
            contain = 0;
        end

        % ML detection
        left_side = dot(s,s)-2*dot(s,x);
        right_side = -2*n_var*log(PH0/PH1);
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

        % Bayes detection
        left_side = dot(s,s)-2*dot(s,x);
        right_side = -2*n_var*log((2/1)*(PH0/PH1));
        if left_side < right_side
            %result = 1; 
            if contain == 0
                Bayes_detect_fail = Bayes_detect_fail+1;
                Bayes_false_alram = Bayes_false_alarm+1;
            elseif contain == 1
                Bayes_detect_suceed = Bayes_detect_suceed+1;
            end
            %disp('s(t) is detected');
        else
            %result = 0; 
            if contain == 0
                Bayes_detect_suceed = Bayes_detect_suceed+1;
            elseif contain == 1
                Bayes_detect_fail = Bayes_detect_fail+1;
                Bayes_false_dismissal = Bayes_false_dismissal+1;
            end
            %disp('x(t) does not contain s(t)');
        end

        cnt = [cnt,i];

        %fprintf('test %d\n',cnt(i));
        ML_p = [ML_p,ML_detect_suceed/(ML_detect_suceed+ML_detect_fail)];
        ML_p_false_alarm = [ML_p_false_alarm,ML_false_alarm/(ML_detect_suceed+ML_detect_fail)];
        ML_p_false_dismissal = [ML_p_false_dismissal,ML_false_dismissal/(ML_detect_suceed+ML_detect_fail)];
        ML_risk = [ML_risk,0+2*ML_p_false_alarm(i)+ML_p_false_dismissal(i)+0];


        Bayes_p = [Bayes_p,Bayes_detect_suceed/(Bayes_detect_suceed+Bayes_detect_fail)];
        Bayes_p_false_alarm = [Bayes_p_false_alarm,Bayes_false_alarm/(Bayes_detect_suceed+Bayes_detect_fail)];
        Bayes_p_false_dismissal = [Bayes_p_false_dismissal,Bayes_false_dismissal/(Bayes_detect_suceed+Bayes_detect_fail)];
        Bayes_risk = [Bayes_risk,0+2*Bayes_p_false_alarm(i)+Bayes_p_false_dismissal(i)+0];

    end

    fprintf('P(H1) = %f, P(H0) = %f\n',PH1,PH0);
    fprintf('ML   : detection rate:%f%%, ',ML_p(100)*100);
    fprintf('false alarm rate:%f%%, false dismissal rate:%f%%, ',ML_p_false_alarm(100)*100, ML_p_false_dismissal(100)*100);
    fprintf('risk:%f\n',ML_risk(100));
    fprintf('Bayes: detection rate:%f%%, ',Bayes_p(100)*100);
    fprintf('false alarm rate:%f%%, false dismissal rate:%f%%, ',Bayes_p_false_alarm(100)*100, Bayes_p_false_dismissal(100)*100);
    fprintf('risk:%f\n',Bayes_risk(100));
    
    MLChange_p = [MLChange_p,ML_p(100)];
    MLChange_p_false_alarm = [MLChange_p_false_alarm,ML_p_false_alarm(100)];
    MLChange_p_false_dismissal = [MLChange_p_false_dismissal,ML_p_false_dismissal(100)]; 
    MLChange_risk = [MLChange_risk,ML_risk(100)];
    BayesChange_p = [BayesChange_p,Bayes_p(100)];
    BayesChange_p_false_alarm = [BayesChange_p_false_alarm,Bayes_p_false_alarm(100)];
    BayesChange_p_false_dismissal = [BayesChange_p_false_dismissal,Bayes_p_false_dismissal(100)]; 
    BayesChange_risk = [BayesChange_risk,Bayes_risk(100)];
end

subplot(4,2,1);plot([0.3,0.4,0.5,0.6,0.7],MLChange_p*100);ylabel('%');title('ML detection rate');
subplot(4,2,3);plot([0.3,0.4,0.5,0.6,0.7],MLChange_p_false_alarm*100);ylabel('%');title('ML false alarm rate');
subplot(4,2,5);plot([0.3,0.4,0.5,0.6,0.7],MLChange_p_false_dismissal*100);ylabel('%');title('ML false dismissal rate');
subplot(4,2,7);plot([0.3,0.4,0.5,0.6,0.7],MLChange_risk);xlabel('P(H1)');title('ML risk');

subplot(4,2,2);plot([0.3,0.4,0.5,0.6,0.7],BayesChange_p*100);ylabel('%');title('Bayes detection rate');
subplot(4,2,4);plot([0.3,0.4,0.5,0.6,0.7],BayesChange_p_false_alarm*100);ylabel('%');title('Bayes false dismissal rate');
subplot(4,2,6);plot([0.3,0.4,0.5,0.6,0.7],BayesChange_p_false_dismissal*100);ylabel('%');title('Bayes false dismissal rate');
subplot(4,2,8);plot([0.3,0.4,0.5,0.6,0.7],BayesChange_risk);xlabel('P(H1)');title('Bayes risk');