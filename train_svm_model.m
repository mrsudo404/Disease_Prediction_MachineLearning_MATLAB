function model = train_svm_model(X_train, y_train)
    % Train SVM model with linear kernel and standardization
    baseModel = fitcsvm(X_train, y_train, ...
        'KernelFunction', 'linear', ...
        'Standardize', true, ...
        'ClassNames', [0, 1]);

    % Enable probability estimates using posterior probabilities
    model = fitPosterior(baseModel);
end
