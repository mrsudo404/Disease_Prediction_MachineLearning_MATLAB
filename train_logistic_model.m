function model = train_logistic_model(X_train, y_train)
    % Train logistic regression model
    model = fitglm(X_train, y_train, 'linear', 'Link', 'logit');
end
