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

    % GUI Window (increased height to 800)
    fig = figure('Name', 'Disease Predictor - Select Model', ...
                 'Position', [100, 100, 420, 800], ...
                 'MenuBar', 'none', 'NumberTitle', 'off');

    % Feature names
    feature_names = {'Pregnancies', 'Glucose', 'Blood Pressure', ...
                     'Skin Thickness', 'Insulin', 'BMI', ...
                     'Diabetes Pedigree', 'Age'};

    input_fields = gobjects(1, numel(feature_names));
    for i = 1:numel(feature_names)
        y_pos = 760 - i * 38;  % Start high, 40px spacing
        uicontrol('Style', 'text', 'Position', [30, y_pos, 150, 20], ...
            'String', [feature_names{i} ':'], 'HorizontalAlignment', 'left');
        input_fields(i) = uicontrol('Style', 'edit', ...
            'Position', [200, y_pos, 150, 25]);
    end

    % Model selection dropdown (moved down to avoid overlapping)
    uicontrol('Style', 'text', 'Position', [30, 420, 150, 20], ...
        'String', 'Select Model:', 'HorizontalAlignment', 'left');
    model_dropdown = uicontrol('Style', 'popupmenu', ...
        'String', {'Logistic Regression', 'SVM', 'Linear Regression'}, ...
        'Position', [200, 420, 150, 25]);

    % Predict Button (lowered)
    uicontrol('Style', 'pushbutton', 'String', 'Predict', ...
        'Position', [150, 360, 100, 40], ...
        'Callback', @predict_callback);

    % Output Text (lowered)
    result_text = uicontrol('Style', 'text', ...
        'Position', [50, 300, 320, 40], ...
        'FontSize', 12, 'FontWeight', 'bold');

    % Callback function
    function predict_callback(~, ~)
        input_values = zeros(1, numel(input_fields));
        for j = 1:numel(input_fields)
            val = str2double(get(input_fields(j), 'String'));
            if isnan(val)
                set(result_text, 'String', 'Please enter valid numeric values.');
                return;
            end
            input_values(j) = val;
        end

        % Normalize input
        norm_input = (input_values - mu) ./ sigma;

        % Predict based on selected model
        selected_model = get(model_dropdown, 'Value');
        switch selected_model
            case 1
                prediction = round(predict(log_model, norm_input));
            case 2
                prediction = round(predict(svm_model, norm_input));
            case 3
                prediction = round(predict(lin_model, norm_input));

        end

        % Display result
        if prediction == 1
            set(result_text, 'String', 'Prediction: Positive for Disease');
        else
            set(result_text, 'String', 'Prediction: Negative for Disease');
        end
    end
end
