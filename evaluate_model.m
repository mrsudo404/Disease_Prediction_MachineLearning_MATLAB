
% evaluate_all_models.m
% Disease Prediction using Logistic Regression or SVM
% Dataset: diabetes_dataset.csv

% Load dataset
data = readtable('diabetes_dataset.csv');

% Extract features and target
X = table2array(data(:, 1:end-1));
y = table2array(data(:, end));

% Fix target variable to ensure binary labels
if iscell(y)
    y = strcmpi(y, 'Positive') | strcmpi(y, '1') | strcmpi(y, 'Yes');
elseif iscategorical(y)
    y = double(y) - 1;
elseif ~isnumeric(y)
    y = double(y);
end

% Ensure y contains only 0 and 1
if ~all(ismember(unique(y), [0, 1]))
    error('Target labels must be binary (0 or 1). Found: %s', mat2str(unique(y)));
end

% Split into training and testing sets
cv = cvpartition(y, 'HoldOut', 0.3);
X_train = X(training(cv), :);
X_test = X(test(cv), :);
y_train = y(training(cv));
y_test = y(test(cv));

% Normalize features using training data
mu = mean(X_train);
sigma = std(X_train);
X_train_norm = (X_train - mu) ./ sigma;
X_test_norm = (X_test - mu) ./ sigma;

% Save mu and sigma for GUI use
save('mu_sigma.mat', 'mu', 'sigma');

% Train Logistic Regression
log_model = fitglm(X_train_norm, y_train, 'Distribution', 'binomial');

% Train Linear SVM
svm_linear = fitcsvm(X_train_norm, y_train, 'KernelFunction', 'linear');

% Train SVM with RBF kernel
svm_rbf = fitcsvm(X_train_norm, y_train, 'KernelFunction', 'rbf');

% Save Logistic Model for GUI
final_model = log_model;
save('logistic_model.mat', 'final_model');

% Store models for evaluation
models = {log_model, svm_linear, svm_rbf};
names = {'Logistic Regression', 'Linear SVM', 'SVM (RBF)'};

% Evaluate each model
for i = 1:length(models)
    model = models{i};
    name = names{i};

    % Make predictions
    if isa(model, 'GeneralizedLinearModel')
        probs = predict(model, X_test_norm);
        preds = round(probs);  % Threshold at 0.5
    else
        preds = predict(model, X_test_norm);
    end

    % Calculate accuracy
    acc = sum(preds == y_test) / numel(y_test) * 100;
    fprintf('%s Accuracy: %.2f%%\n', name, acc);

    % Display confusion matrix
    figure;
    confusionchart(y_test, preds);
    title(['Confusion Matrix - ' name]);
end
