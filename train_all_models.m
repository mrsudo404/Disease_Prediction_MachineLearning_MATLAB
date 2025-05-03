% Load dataset
data = readtable('diabetes_dataset.csv');

% Prepare features and labels
X = table2array(data(:, 1:end-1));
y = table2array(data(:, end));

% Convert labels to binary (0 and 1)
y = double(categorical(y));
y = y - min(y);  % Ensures labels are 0 or 1

% Train-test split
cv = cvpartition(y, 'HoldOut', 0.3);
X_train = X(training(cv), :);
y_train = y(training(cv));
X_test = X(test(cv), :);
y_test = y(test(cv));

% Normalize features
mu = mean(X_train);
sigma = std(X_train);
X_train_norm = (X_train - mu) ./ sigma;
X_test_norm = (X_test - mu) ./ sigma;

% --- Train Logistic Regression ---
log_model = fitglm(X_train_norm, y_train, 'Distribution', 'binomial');
save('logistic_model.mat', 'log_model');

% --- Train SVM ---
svm_model = fitcsvm(X_train_norm, y_train, 'KernelFunction', 'rbf', 'Standardize', false);
save('svm_model.mat', 'svm_model');

% --- Train Linear Regression as Classifier ---
lin_model = fitlm(X_train_norm, y_train);
save('linear_model.mat', 'lin_model');

% --- Save normalization stats ---
save('mu_sigma.mat', 'mu', 'sigma');

% --- Generate and save confusion matrices ---
log_preds = round(predict(log_model, X_test_norm));
figure; confusionchart(y_test, log_preds);
title('Confusion Matrix - Logistic Regression');
saveas(gcf, 'confusion_logistic.png');

svm_preds = predict(svm_model, X_test_norm);
figure; confusionchart(y_test, svm_preds);
title('Confusion Matrix - SVM');
saveas(gcf, 'confusion_svm.png');

lin_probs = predict(lin_model, X_test_norm);
lin_preds = double(lin_probs >= 0.5);
figure; confusionchart(y_test, lin_preds);
title('Confusion Matrix - Linear Regression');
saveas(gcf, 'confusion_linear.png');

disp('Training complete. Models and figures saved.');
