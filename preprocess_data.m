function [X_train, X_test, y_train, y_test] = preprocess_data()
    data = readtable('diabetes_dataset.csv');

    % Convert table to array
    data = table2array(data);

    % Normalize features
    X = data(:, 1:end-1);
    X = (X - min(X)) ./ (max(X) - min(X));
    
    y = data(:, end); % Target column (diabetes: 0 or 1)

    % Train/test split (80%/20%)
    cv = cvpartition(size(X, 1), 'HoldOut', 0.2);
    idx = cv.test;

    X_train = X(~idx, :);
    y_train = y(~idx);
    X_test = X(idx, :);
    y_test = y(idx);
end
