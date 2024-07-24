function [fitresult, gof] = createFit_power4(x, y)
%CREATEFIT(X,Y)
%  Create a fit.
%
%  Data for 'power4_fit' fit:
%      X Input: x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 09-Jul-2024 14:56:26


%% Fit: 'power4_fit'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
% ft = fittype( 'a/x^(1/4)+b', 'independent', 'x', 'dependent', 'y' );
ft = fittype( 'a/x^(1/4)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
% opts.StartPoint = [0.0357116785741896 0.849129305868777];
opts.StartPoint = 0.0357116785741896;


% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% % Plot fit with data.
% figure( 'Name', 'power4_fit' );
% h = plot( fitresult, xData, yData );
% legend( h, 'y vs. x', 'power4_fit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'x', 'Interpreter', 'none' );
% ylabel( 'y', 'Interpreter', 'none' );
% grid on


