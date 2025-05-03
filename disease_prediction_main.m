function disease_predictor_gui
    % Load trained models and normalization stats
    stats = load('mu_sigma.mat');     % contains mu and sigma
    mu = stats.mu;
    sigma = stats.sigma;

    log_data = load('logistic_model.mat');  % contains: log_model
    log_model = log_data.log_model;

    svm_data = load('svm_model.mat');       % contains: svm_model
    svm_model = svm_data.svm_model;

    lin_data = load('linear_model.mat');    % contains: lin_model
    lin_model = lin_data.lin_model;

    % GUI Window (height increased for 8 fields + controls)
    fig = figure('Name', 'Disease Predictor - Select Model', ...
                 'Position', [100, 100, 420, 720], ...
                 'MenuBar', 'none', 'NumberTitle', 'off');

    % Feature names
    feature_names = {'Pregnancies', 'Glucose', 'Blood Pressure', ...
                     'Skin Thickness', 'Insulin', 'BMI', ...
                     'Diabetes Pedigree', 'Age'};

    input_fields = gobjects(1, numel(feature_names));
    for i = 1:numel(feature_names)
        y_pos = 680 - i*50;
        uicontrol('Style', 'text', 'Position', [30, y_pos, 150, 20], ...
            'String', [feature_names{i} ':'], 'HorizontalAlignment', 'left');
        input_fields(i) = uicontrol('Style', 'edit', ...
            'Position', [200, y_pos, 150, 25]);
    end

    % Dropdown to select model
    uicontrol('Style', 'text', 'Position', [30, 280, 150, 20], ...
        'String', 'Select Model:', 'HorizontalAlignment', 'left');
    model_dropdown = uicontrol('Style', 'popupmenu', ...
        'Position', [200, 280, 150, 25], ...
        'String', {'Logistic Regression', 'SVM (RBF)', 'Linear Regression'});

    % Predict Button
    uicontrol('Style', 'pushbutton', 'Position', [150, 230, 100, 30], ...
        'String', 'Predict', 'Callback', @predict_callback);

    % Result Display
    result_label = uicontrol('Style', 'text', 'Position', [50, 160, 320, 40], ...
        'String', '', 'FontSize', 12, 'ForegroundColor', 'blue', ...
        'HorizontalAlignment', 'center');

    function predict_callback(~, ~)
        try
            % Read and validate input
            user_input = zeros(1, numel(input_fields));
            for j = 1:numel(input_fields)
                val = str2double(get(input_fields(j), 'String'));
                user_input(j) = val;
            end

            % Check for NaNs
            missing = isnan(user_input);
            if any(missing)
                missing_fields = strjoin(feature_names(missing), ', ');
                errordlg(['Please enter valid numeric values for: ' missing_fields]);
                return;
            end

            normalized_input = (user_input - mu) ./ sigma;

            % Select model
            selected_model = model_dropdown.Value;
            switch selected_model
                case 1  % Logistic Regression
                    pred = round(predict(log_model, normalized_input));
                    model_name = 'Logistic Regression';
                case 2  % SVM
                    pred = predict(svm_model, normalized_input);
                    model_name = 'SVM';
                case 3  % Linear Regression
                    pred = double(predict(lin_model, normalized_input) >= 0.5);
                    model_name = 'Linear Regression';
            end

            % Display result
            if pred == 1
                set(result_label, 'String', ['Prediction: Disease Detected (' model_name ')'], ...
                    'ForegroundColor', 'red');
            else
                set(result_label, 'String', ['Prediction: No Disease (' model_name ')'], ...
                    'ForegroundColor', 'green');
            end

        catch ME
            errordlg(['Error: ' ME.message]);
        end
    end
end
