function varargout = RSFitOSC(varargin)
% RSFitOSC MATLAB code for RSFitOSC.fig
%      RSFitOSC, by itself, creates a new RSFitOSC or raises the existing
%      singleton*.
%
%      H = RSFitOSC returns the handle to a new RSFitOSC or the handle to
%      the existing singleton*.
%
%      RSFitOSC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RSFitOSC.M with the given input arguments.
%
%      RSFitOSC('Property','Value',...) creates a new RSFitOSC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RSFitOSC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RSFitOSC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RSFitOSC

% Last Modified by GUIDE v2.5 21-Oct-2019 09:58:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RSFitOSC_OpeningFcn, ...
                   'gui_OutputFcn',  @RSFitOSC_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RSFitOSC is made visible.
function RSFitOSC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RSFitOSC (see VARARGIN)

%%% Choose default command line output for RSFitOSC
handles.output = hObject;

%%% Update handles structure
guidata(hObject, handles);

%%% Populate the listbox
update_listbox(handles)

%%% Set the sample slip flag to "false", and disable the sample slip field.
setappdata(handles.FitButton, 'SampleSlipFlag', false);

%%% Set the velocity step button to "on", disable the SHS panel, and set the
%%% event flag.
%set(handles.EventButtonGroup,'selectedobject',handles.VelocityStepButton);
%setappdata(handles.FitButton, 'EventFlag', true);
%set(findall(handles.SHSPanel, '-property', 'Enable'), 'Enable', 'off');

%%% Set the two state variable button to "off" and set the state variable
%%% flag.
setappdata(handles.FitButton, 'StateVarFlag', false);
%%% Disable the additional state variable fields.
set(handles.Guess_b2Value, 'Enable', 'off')
set(handles.AgingFit_b2Value, 'Enable', 'off')
set(handles.SlipFit_b2Value, 'Enable', 'off')
set(handles.Guess_dc2Value, 'Enable', 'off')
set(handles.AgingFit_dc2Value, 'Enable', 'off')
set(handles.SlipFit_dc2Value, 'Enable', 'off')

%%% Set the StiffnessFlag and MuFlag to "true", WeightFlag to "off", and
%%% the respective buttons to "off"
set(handles.WeightButton, 'value', 0);
setappdata(handles.FitButton, 'WeightFlag', false);
set(handles.MuButton, 'value', 0);
setappdata(handles.FitButton, 'MuFlag', true);
set(handles.StiffnessButton, 'value', 0);
setappdata(handles.FitButton, 'StiffnessFlag', true);

%%% Disable the weighting panel
set(findall(handles.WeightPanel, '-property', 'Enable'), 'Enable', 'off');

%%% Set both Aging and Slip Law fit buttons to on, and enable their fields.
set(handles.AgingButton, 'value', 1);
setappdata(handles.FitButton, 'AgingLawFlag', true);
set(handles.AgingFit_muValue, 'Enable', 'on');
set(handles.AgingFit_aValue, 'Enable', 'on');
set(handles.AgingFit_bValue, 'Enable', 'on');
set(handles.AgingFit_dcValue, 'Enable', 'on');
set(handles.AgingFit_kValue, 'Enable', 'on');
set(handles.SlipButton, 'value', 1);
setappdata(handles.FitButton, 'SlipLawFlag', true);
set(handles.SlipFit_muValue, 'Enable', 'on');
set(handles.SlipFit_aValue, 'Enable', 'on');
set(handles.SlipFit_bValue, 'Enable', 'on');
set(handles.SlipFit_dcValue, 'Enable', 'on');
set(handles.SlipFit_kValue, 'Enable', 'on');

%%% Display the logo.
try
    Logo = imread('RSFitLogo_small.jpg');
    image(handles.LogoAxes, Logo);
    axis(handles.LogoAxes, 'off');
    axis image
catch
    axis(handles.LogoAxes, 'off');
    warning('Logo image missing.');
end

% UIWAIT makes RSFitOSC wait for user response (see UIRESUME)
% uiwait(handles.RASGUI);


% --- Outputs from this function are returned to the command line.
function varargout = RSFitOSC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Guess_muValue_Callback(hObject, eventdata, handles)
% hObject    handle to Guess_muValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Guess_muValue as text
%        str2double(get(hObject,'String')) returns contents of Guess_muValue as a double


% --- Executes during object creation, after setting all properties.
function Guess_muValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Guess_muValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Guess_aValue_Callback(hObject, eventdata, handles)
% hObject    handle to Guess_aValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Guess_aValue as text
%        str2double(get(hObject,'String')) returns contents of Guess_aValue as a double


% --- Executes during object creation, after setting all properties.
function Guess_aValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Guess_aValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Guess_bValue_Callback(hObject, eventdata, handles)
% hObject    handle to Guess_bValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Guess_bValue as text
%        str2double(get(hObject,'String')) returns contents of Guess_bValue as a double


% --- Executes during object creation, after setting all properties.
function Guess_bValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Guess_bValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Guess_dcValue_Callback(hObject, eventdata, handles)
% hObject    handle to Guess_dcValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Guess_dcValue as text
%        str2double(get(hObject,'String')) returns contents of Guess_dcValue as a double


% --- Executes during object creation, after setting all properties.
function Guess_dcValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Guess_dcValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Guess_kValue_Callback(hObject, eventdata, handles)
% hObject    handle to Guess_kValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Guess_kValue as text
%        str2double(get(hObject,'String')) returns contents of Guess_kValue as a double


% --- Executes during object creation, after setting all properties.
function Guess_kValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Guess_kValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FitButton.
function FitButton_Callback(hObject, eventdata, handles)
% hObject    handle to FitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Clear any previously stored fit data.
    setappdata(handles.FitButton,'X0',[ ]);
    setappdata(handles.FitButton,'XF_Aging',[ ]);
    setappdata(handles.FitButton,'SlipFit_Aging',[ ]);
    setappdata(handles.FitButton,'FrictionFit_Aging',[ ]);
    setappdata(handles.FitButton,'SampleSlipFit_Aging', [ ]);
    setappdata(handles.FitButton,'AgingErrors',[ ]);
    setappdata(handles.FitButton,'XF_Slip',[ ]);
    setappdata(handles.FitButton,'SlipFit_Slip',[ ]);
    setappdata(handles.FitButton,'FrictionFit_Slip',[ ]);
    setappdata(handles.FitButton,'SampleSlipFit_Slip', [ ]);
    setappdata(handles.FitButton,'SlipErrors',[ ]);
    setappdata(handles.FitButton, 'ExitFlag', [ ]);
    setappdata(handles.FitButton, 'Residuals', [ ]);
%%% Clear the fit parameters windows.
    set(handles.AgingFit_muValue, 'String', [ ]);  
    set(handles.AgingFit_aValue, 'String', [ ]);
    set(handles.AgingFit_bValue, 'String', [ ]);
    set(handles.AgingFit_dcValue, 'String', [ ]);
    set(handles.AgingFit_kValue, 'String', [ ]);
    set(handles.AgingFit_b2Value, 'String', [ ]);
    set(handles.AgingFit_dc2Value, 'String', [ ]);
    set(handles.AgingRes, 'String', [ ]);
    set(handles.AgingFlag, 'String', [ ]);
    set(handles.SlipFit_muValue, 'String', [ ]);  
    set(handles.SlipFit_aValue, 'String', [ ]);
    set(handles.SlipFit_bValue, 'String', [ ]);
    set(handles.SlipFit_dcValue, 'String', [ ]);
    set(handles.SlipFit_kValue, 'String', [ ]);
    set(handles.SlipFit_b2Value, 'String', [ ]);
    set(handles.SlipFit_dc2Value, 'String', [ ]);
    set(handles.SlipRes, 'String',[ ]);    
    set(handles.SlipFlag, 'String', [ ]);
%%% Clear any previously plotted fits.
children = get(handles.FittingAxes, 'children');
if numel(children) > 1
    for i = 1:numel(children)
        if strcmp('-', get(children(i), 'LineStyle'))
            delete(children(i));
        end
    end
end

    
%%% Get the stuff.
    [x_0, x_e, x_L, NormStress, Slip_ZeroRef, Time_ZeroRef, StateVarFlag,...
        StiffnessFlag, MuFlag, Weight] = GetStuff(handles);
%%% Check if using sample slip data.
    SampleSlipFlag = getappdata(handles.FitButton, 'SampleSlipFlag');
%%% Check what fits to do.
    AgingLawFlag = getappdata(handles.FitButton, 'AgingLawFlag');
    SlipLawFlag = getappdata(handles.FitButton, 'SlipLawFlag');
%%% Store the normal stress.
    setappdata(handles.FitButton, 'NormStressStep', NormStress);
%%% Get the friction data and carry out the inversion.
    Friction_Detrend = getappdata(handles.DetrendButton,'FrictionDetrend_Data');    
    FrictionVariability = sum((Friction_Detrend - mean(Friction_Detrend)).^2);

%%% Aging law fit.
if AgingLawFlag == 1
    StateLawFlag = true;
%    if EventFlag
%        try
%        setappdata(handles.FitButton,'StepTime',Period);
%        [~,x_f,~,~,~,Mu_f,Slip_f,SampleSlip_f,exitflagA,~,residualA,jacobian,resnorm]...
%            = RASFittingLD1(x_0,x_e,x_L,NormStress,Mu_Data,LoadPointSlip,Exp_Time,...
%            StateLawFlag,StateVarFlag,EventFlag,StiffnessFlag,MuFlag,Weight,...
%            SampleSlipFlag,handles);
%        catch ME
%            disp(ME.message)
%            msg = 'ODE solver failure';
%            error(msg);
%        end
%    else
        %try
%        HoldTime = varargout{1};
%        TimeOfHold = varargout{2};
%        setappdata(handles.FitButton,'Hold_Time',TimeOfHold);
        [~,x_f,~,~,~,Mu_f,Slip_f,SampleSlip_f,exitflagA,~,residualA,jacobian,resnorm]...
            = RASFittingLD1(x_0,x_e,x_L,NormStress,Friction_Detrend,Slip_ZeroRef,...
            Time_ZeroRef,StateLawFlag,StateVarFlag,StiffnessFlag,MuFlag,...
            Weight,SampleSlipFlag,handles);
        %catch ME
        %    disp(ME.message)
        %    msg = 'ODE solver failure';
        %    error(msg);
        %end
%    end
    
%%% Compute the R-squared value.   
    FrictionResidualA = sum((Mu_f - Friction_Detrend).^2);
    FrictionCOD_A = 1 - FrictionResidualA/FrictionVariability;
    set(handles.AgingRes, 'String', num2str(FrictionCOD_A));

%%% Compute standard deviation. Two-sigma error.
    if StateVarFlag          
        x_fA = x_f;
        if StiffnessFlag == true && MuFlag == true
            N = numel(Time_ZeroRef) - 7;
            jacA = jacobian;
            CovarA = resnorm*(inv(jacA'*jacA))/N;
            ErrorsA = 2*sqrt(resnorm*diag(inv(jacA'*jacA))/N);
            mu_0Error = ErrorsA(1,1);
            aError = ErrorsA(2,1);
            b1Error = ErrorsA(3,1);
            d_c1Error = ErrorsA(4,1);
            kError = ErrorsA(5,1);
            b2Error = ErrorsA(6,1);
            d_c2Error = ErrorsA(7,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 + (b2Error/2)^2 ...
                + 2*CovarA(3,6) - 2*CovarA(2,3) - 2*CovarA(2,6));
        elseif StiffnessFlag == false && MuFlag == true
            N = numel(Time_ZeroRef) - 6;
            jacA = [jacobian(:,1:4), jacobian(:,6:7)];
            CovarA = resnorm*(inv(jacA'*jacA))/N;
            ErrorsA = 2*sqrt(resnorm*diag(inv(jacA'*jacA))/N);
            mu_0Error = ErrorsA(1,1);
            aError = ErrorsA(2,1);
            b1Error = ErrorsA(3,1);
            d_c1Error = ErrorsA(4,1);
            b2Error = ErrorsA(5,1);
            d_c2Error = ErrorsA(6,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 + (b2Error/2)^2 ...
                + 2*CovarA(3,5) - 2*CovarA(2,3) - 2*CovarA(2,5));
        elseif StiffnessFlag == true && MuFlag == false
            N = numel(Time_ZeroRef) - 6;
            jacA = jacobian(:,2:7);
            CovarA = resnorm*(inv(jacA'*jacA))/N;
            ErrorsA = 2*sqrt(resnorm*diag(inv(jacA'*jacA))/N);
            aError = ErrorsA(1,1);
            b1Error = ErrorsA(2,1);
            d_c1Error = ErrorsA(3,1);
            kError = ErrorsA(4,1);
            b2Error = ErrorsA(5,1);
            d_c2Error = ErrorsA(6,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 + (b2Error/2)^2 ...
                + 2*CovarA(2,5) - 2*CovarA(1,2) - 2*CovarA(1,5));
        else
            N = numel(Time_ZeroRef) - 5;
            jacA = [jacobian(:,2:4), jacobian(:,6:7)];
            CovarA = resnorm*(inv(jacA'*jacA))/N;
            ErrorsA = 2*sqrt(resnorm*diag(inv(jacA'*jacA))/N);
            aError = ErrorsA(1,1);
            b1Error = ErrorsA(2,1);
            d_c1Error = ErrorsA(3,1);
            b2Error = ErrorsA(4,1);
            d_c2Error = ErrorsA(5,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 + (b2Error/2)^2 ...
                + 2*CovarA(2,5) - 2*CovarA(1,2) - 2*CovarA(1,4));
        end
        b2String = [strrep(sprintf('%0.2e ', x_fA(6)), 'e-0', 'e-'), char(177),...
            strrep(sprintf(' %0.2e', b2Error), 'e-0', 'e-')];    
        d_c2String = [sprintf('%0.3f ', x_fA(7)), char(177),...
            sprintf(' %0.3f', d_c2Error)];
        set(handles.AgingFit_b2Value, 'String', b2String);
        set(handles.AgingFit_dc2Value, 'String', d_c2String);
    else
        x_fA = x_f(1:5);
        if StiffnessFlag == true && MuFlag == true
            N = numel(Time_ZeroRef) - 5;
            jacA = jacobian(:,1:5);
            CovarA = resnorm*(inv(jacA'*jacA))/N;
            ErrorsA = 2*sqrt(resnorm*diag(inv(jacA'*jacA))/N);
            mu_0Error = ErrorsA(1,1);
            aError = ErrorsA(2,1);
            b1Error = ErrorsA(3,1);
            d_c1Error = ErrorsA(4,1);
            kError = ErrorsA(5,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 - 2*CovarA(2,3));
        elseif StiffnessFlag == false && MuFlag == true
            N = numel(Time_ZeroRef) - 4;
            jacA = jacobian(:,1:4);
            CovarA = resnorm*(inv(jacA'*jacA))/N;
            ErrorsA = 2*sqrt(resnorm*diag(inv(jacA'*jacA))/N);
            mu_0Error = ErrorsA(1,1);
            aError = ErrorsA(2,1);
            b1Error = ErrorsA(3,1);
            d_c1Error = ErrorsA(4,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 - 2*CovarA(2,3));
        elseif StiffnessFlag == true && MuFlag == false
            N = numel(Time_ZeroRef) - 4;
            jacA = jacobian(:,2:5);
            CovarA = resnorm*(inv(jacA'*jacA))/N;
            ErrorsA = 2*sqrt(resnorm*diag(inv(jacA'*jacA))/N);
            aError = ErrorsA(1,1);
            b1Error = ErrorsA(2,1);
            d_c1Error = ErrorsA(3,1);
            kError = ErrorsA(4,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 - 2*CovarA(1,2));
        else
            N = numel(Time_ZeroRef) - 3;
            jacA = jacobian(:,2:4);
            CovarA = resnorm*(inv(jacA'*jacA))/N;
            ErrorsA = 2*sqrt(resnorm*diag(inv(jacA'*jacA))/N);
            aError = ErrorsA(1,1);
            b1Error = ErrorsA(2,1);
            d_c1Error = ErrorsA(3,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 - 2*CovarA(1,2));
        end
    end        
    
%%% Format the numbers for main parameters to print in the gui.
    if StiffnessFlag == true
        kString = [strrep(sprintf('%0.2e ', x_fA(5)), 'e-0', 'e-'), char(177),...
            strrep(sprintf(' %0.2e', kError), 'e-0', 'e-')];
        set(handles.AgingFit_kValue, 'String', kString);
    else
        x_f(5,1) = x_e(2,1);
        kError = 0;
    end
    if MuFlag == true
        mu_0String = [strrep(sprintf('%0.2e ', x_fA(1)), 'e-0', 'e-'), char(177),...
            strrep(sprintf(' %0.2e', mu_0Error), 'e-0', 'e-')];
        set(handles.AgingFit_muValue, 'String', mu_0String);
    else
        x_f(1,1) = x_e(1,1);
        mu_0Error = 0;
    end
    aString = [strrep(sprintf('%0.2e ', x_fA(2)), 'e-0', 'e-'), char(177),...
        strrep(sprintf(' %0.2e', aError), 'e-0', 'e-')];
    b1String = [strrep(sprintf('%0.2e ', x_fA(3)), 'e-0', 'e-'), char(177),...
        strrep(sprintf(' %0.2e', b1Error), 'e-0', 'e-')];
    d_c1String = [sprintf('%0.3f ', x_fA(4)), char(177),...
        sprintf(' %0.3f', d_c1Error)];
%%% Display the fitted parameters in aging law fields.    
    set(handles.AgingFit_aValue, 'String', aString);
    set(handles.AgingFit_bValue, 'String', b1String);
    set(handles.AgingFit_dcValue, 'String', d_c1String);
%%% Plot the fit over the detrended data in the fitting axes. 
    hold(handles.FittingAxes, 'on');
%    if EventFlag
%        PAgingFit = plot(handles.FittingAxes,Slip_f, Mu_f, 'r', 'LineWidth', 2);
%    else
        PAgingFit = plot(handles.FittingAxes,Time_ZeroRef, Mu_f, 'r', 'LineWidth', 2);
%    end
    hold(handles.FittingAxes, 'off');   
%%% Store the fitted parameters and data.
    setappdata(handles.FitButton,'X0',x_0);
    setappdata(handles.FitButton,'XF_Aging',x_f);
    setappdata(handles.FitButton,'SlipFit_Aging',Slip_f);
    setappdata(handles.FitButton,'FrictionFit_Aging',Mu_f);
    setappdata(handles.FitButton,'CovarianceA',CovarA);
    
%%% Store the error intervals.
    if StateVarFlag == true
        AgingError = [mu_0Error; aError; b1Error; b2Error; d_c1Error;...
            d_c2Error; kError; aminusbError];
    else
        AgingError = [mu_0Error; aError; b1Error; 0; d_c1Error;...
            0; kError; aminusbError];
    end
    setappdata(handles.FitButton,'AgingErrors',AgingError);        
end 

%%%------------------------ Start Slip Law -----------------------------%%%
if SlipLawFlag == 1
%%% Slip law fit.
    StateLawFlag = false;
%    if EventFlag
%        try
%        setappdata(handles.FitButton,'StepTime',Period);
%        [~,x_f,~,~,~,Mu_f,Slip_f,SampleSlip_f,exitflagS,~,residualS,jacobian,resnorm]...
%            = RASFittingLD1(x_0,x_e,v_i,v_amp,NormStress,Period,Friction_Detrend,...
%            Slip_ZeroRef,Time_ZeroRef,StateLawFlag,StateVarFlag,EventFlag,...
%            StiffnessFlag,MuFlag,Weight,SampleSlipFlag,handles);
%        catch ME
%            disp(ME.message)
%            msg = 'ODE solver failure';
%            error(msg);
%        end
%    else
        %try
%        HoldTime = varargout{1};
%        TimeOfHold = varargout{2};
%        setappdata(handles.FitButton,'Hold_Time',TimeOfHold);
        [~,x_f,~,~,~,Mu_f,Slip_f,SampleSlip_f,exitflagS,~,residualS,jacobian,resnorm]...
            = RASFittingLD1(x_0,x_e,x_L,NormStress,Friction_Detrend,Slip_ZeroRef,...
            Time_ZeroRef,StateLawFlag,StateVarFlag,StiffnessFlag,MuFlag,...
            Weight,SampleSlipFlag,handles);
        %catch ME
        %    disp(ME.message)
        %    msg = 'ODE solver failure';
        %    error(msg);
        %end
%    end

%%% Compute, display, and store R-squared values.  
    FrictionResidualS = sum((Mu_f - Friction_Detrend).^2);
    FrictionCOD_S = 1 - FrictionResidualS/FrictionVariability;
    set(handles.SlipRes, 'String', num2str(FrictionCOD_S));    
%%%---------------------------------------------------------------------%%%

%%% Compute standard deviation. Two-sigma error.
    if StateVarFlag          
        x_fS = x_f;
        if StiffnessFlag == true && MuFlag == true
            N = numel(Time_ZeroRef) - 7;
            jacS = jacobian;
            CovarS = resnorm*(inv(jacS'*jacS))/N;
            ErrorsS = 2*sqrt(resnorm*diag(inv(jacS'*jacS))/N);
            mu_0Error = ErrorsS(1,1);
            aError = ErrorsS(2,1);
            b1Error = ErrorsS(3,1);
            d_c1Error = ErrorsS(4,1);
            kError = ErrorsS(5,1);
            b2Error = ErrorsS(6,1);
            d_c2Error = ErrorsS(7,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 + (b2Error/2)^2 ...
                + 2*CovarS(3,6) - 2*CovarS(2,3) - 2*CovarS(2,6));
        elseif StiffnessFlag == false && MuFlag == true
            N = numel(Time_ZeroRef) - 6;
            jacS = [jacobian(:,1:4), jacobian(:,6:7)];
            CovarS = resnorm*(inv(jacS'*jacS))/N;
            ErrorsS = 2*sqrt(resnorm*diag(inv(jacS'*jacS))/N);
            mu_0Error = ErrorsS(1,1);
            aError = ErrorsS(2,1);
            b1Error = ErrorsS(3,1);
            d_c1Error = ErrorsS(4,1);
            b2Error = ErrorsS(5,1);
            d_c2Error = ErrorsS(6,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 + (b2Error/2)^2 ...
                + 2*CovarS(3,5) - 2*CovarS(2,3) - 2*CovarS(2,5));
        elseif StiffnessFlag == true && MuFlag == false
            N = numel(Time_ZeroRef) - 6;
            jacS = jacobian(:,2:7);
            CovarS = resnorm*(inv(jacS'*jacS))/N;
            ErrorsS = 2*sqrt(resnorm*diag(inv(jacS'*jacS))/N);
            aError = ErrorsS(1,1);
            b1Error = ErrorsS(2,1);
            d_c1Error = ErrorsS(3,1);
            kError = ErrorsS(4,1);
            b2Error = ErrorsS(5,1);
            d_c2Error = ErrorsS(6,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 + (b2Error/2)^2 ...
                + 2*CovarS(2,5) - 2*CovarS(1,2) - 2*CovarS(1,5));
        else
            N = numel(Time_ZeroRef) - 5;
            jacS = [jacobian(:,2:4), jacobian(:,6:7)];
            CovarS = resnorm*(inv(jacS'*jacS))/N;
            ErrorsS = 2*sqrt(resnorm*diag(inv(jacS'*jacS))/N);
            aError = ErrorsS(1,1);
            b1Error = ErrorsS(2,1);
            d_c1Error = ErrorsS(3,1);
            b2Error = ErrorsS(4,1);
            d_c2Error = ErrorsS(5,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 + (b2Error/2)^2 ...
                + 2*CovarS(2,4) - 2*CovarS(1,2) - 2*CovarS(1,4));
        end
        b2String = [strrep(sprintf('%0.2e ', x_fS(6)), 'e-0', 'e-'), char(177),...
            strrep(sprintf(' %0.2e', b2Error), 'e-0', 'e-')];    
        d_c2String = [sprintf('%0.3f ', x_fS(7)), char(177),...
            sprintf(' %0.3f', d_c2Error)];
        set(handles.SlipFit_b2Value, 'String', b2String);
        set(handles.SlipFit_dc2Value, 'String', d_c2String);
    else
        x_fS = x_f(1:5);
        if StiffnessFlag == true && MuFlag == true
            N = numel(Time_ZeroRef) - 5;
            jacS = jacobian(:,1:5);
            CovarS = resnorm*(inv(jacS'*jacS))/N;
            ErrorsS = 2*sqrt(resnorm*diag(inv(jacS'*jacS))/N);
            mu_0Error = ErrorsS(1,1);
            aError = ErrorsS(2,1);
            b1Error = ErrorsS(3,1);
            d_c1Error = ErrorsS(4,1);
            kError = ErrorsS(5,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 - 2*CovarS(2,3));
        elseif StiffnessFlag == false && MuFlag == true
            N = numel(Time_ZeroRef) - 4;
            jacS = jacobian(:,1:4);
            CovarS = resnorm*(inv(jacS'*jacS))/N;
            ErrorsS = 2*sqrt(resnorm*diag(inv(jacS'*jacS))/N);
            mu_0Error = ErrorsS(1,1);
            aError = ErrorsS(2,1);
            b1Error = ErrorsS(3,1);
            d_c1Error = ErrorsS(4,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 - 2*CovarS(2,3));
        elseif StiffnessFlag == true && MuFlag == false
            N = numel(Time_ZeroRef) - 4;
            jacS = jacobian(:,2:5);
            CovarS = resnorm*(inv(jacS'*jacS))/N;
            ErrorsS = 2*sqrt(resnorm*diag(inv(jacS'*jacS))/N);
            aError = ErrorsS(1,1);
            b1Error = ErrorsS(2,1);
            d_c1Error = ErrorsS(3,1);
            kError = ErrorsS(4,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 - 2*CovarS(1,2));
        else
            N = numel(Time_ZeroRef) - 3;
            jacS = jacobian(:,2:4);
            CovarS = resnorm*(inv(jacS'*jacS))/N;
            ErrorsS = 2*sqrt(resnorm*diag(inv(jacS'*jacS))/N);
            aError = ErrorsS(1,1);
            b1Error = ErrorsS(2,1);
            d_c1Error = ErrorsS(3,1);
            aminusbError = 2*sqrt((aError/2)^2 + (b1Error/2)^2 - 2*CovarS(1,2));
        end
    end        
    
%%% Format the numbers for main parameters to print in the gui.
    if StiffnessFlag == true
        kString = [strrep(sprintf('%0.2e ', x_fS(5)), 'e-0', 'e-'), char(177),...
            strrep(sprintf(' %0.2e', kError), 'e-0', 'e-')];
        set(handles.SlipFit_kValue, 'String', kString);
    else
        x_f(5,1) = x_e(2,1);
        kError = 0;
    end
    if MuFlag == true
        mu_0String = [strrep(sprintf('%0.2e ', x_fS(1)), 'e-0', 'e-'), char(177),...
            strrep(sprintf(' %0.2e', mu_0Error), 'e-0', 'e-')];
        set(handles.SlipFit_muValue, 'String', mu_0String);
    else
        x_f(1,1) = x_e(1,1);
        mu_0Error = 0;
    end
    aString = [strrep(sprintf('%0.2e ', x_fS(2)), 'e-0', 'e-'), char(177),...
        strrep(sprintf(' %0.2e', aError), 'e-0', 'e-')];
    b1String = [strrep(sprintf('%0.2e ', x_fS(3)), 'e-0', 'e-'), char(177),...
        strrep(sprintf(' %0.2e', b1Error), 'e-0', 'e-')];
    d_c1String = [sprintf('%0.3f ', x_fS(4)), char(177),...
        sprintf(' %0.3f', d_c1Error)];
%%% Display the fitted parameters in Slip law fields.    
    set(handles.SlipFit_aValue, 'String', aString);
    set(handles.SlipFit_bValue, 'String', b1String);
    set(handles.SlipFit_dcValue, 'String', d_c1String);
%%% Plot the fit over the detrended data in the fitting axes. 
    hold(handles.FittingAxes, 'on');
%    if EventFlag
%        PSlipFit = plot(handles.FittingAxes,Slip_f, Mu_f, 'c', 'LineWidth', 2);
%    else
        PSlipFit = plot(handles.FittingAxes,Time_ZeroRef, Mu_f, 'c', 'LineWidth', 2);
%    end
    hold(handles.FittingAxes, 'off');
%%% Store the fitted parameters and data.
    setappdata(handles.FitButton,'X0',x_0);
    setappdata(handles.FitButton,'XF_Slip',x_f);
    setappdata(handles.FitButton,'SlipFit_Slip',Slip_f);
    setappdata(handles.FitButton,'FrictionFit_Slip',Mu_f);
    setappdata(handles.FitButton,'CovarianceS',CovarS);
   
%%% Store the error intervals.
    if StateVarFlag == true
        SlipError = [mu_0Error; aError; b1Error; b2Error; d_c1Error;...
            d_c2Error; kError; aminusbError];
    else
        SlipError = [mu_0Error; aError; b1Error; 0; d_c1Error;...
            0; kError; aminusbError];
    end
    setappdata(handles.FitButton,'SlipErrors',SlipError);   
end

%%% Store and display the exit flags.
    if AgingLawFlag == 1 && SlipLawFlag == 1
        setappdata(handles.FitButton, 'ExitFlag', [exitflagA; exitflagS]);
        setappdata(handles.FitButton, 'Residuals', [residualA; residualS]);
        set(handles.AgingFlag, 'String', num2str(exitflagA));
        set(handles.SlipFlag, 'String', num2str(exitflagS));
    elseif AgingLawFlag == 1
        setappdata(handles.FitButton, 'ExitFlag', exitflagA);
        setappdata(handles.FitButton, 'Residuals', residualA);
        set(handles.AgingFlag, 'String', num2str(exitflagA));   
    elseif SlipLawFlag == 1
        setappdata(handles.FitButton, 'ExitFlag', exitflagS);
        setappdata(handles.FitButton, 'Residuals', residualS);
        set(handles.SlipFlag, 'String', num2str(exitflagS));
    end
    
%%% Create the legend and place it based on the event type
LegLoc = 'best';
children = get(handles.FittingAxes, 'children');
if AgingLawFlag == 1 && SlipLawFlag == 1    
    if numel(children) > 3
        PAgingTest = getappdata(handles.TestButton, 'Plot_ATest');
        PSlipTest = getappdata(handles.TestButton, 'Plot_STest');
        legend(handles.FittingAxes, [PAgingTest, PSlipTest, PAgingFit, PSlipFit],...
            'Aging Law Test', 'Slip Law Test', 'Aging Law Fit', 'Slip Law Fit',...
            'Location', LegLoc);
    else
        legend(handles.FittingAxes, [PAgingFit, PSlipFit], 'Aging Law Fit',...
            'Slip Law Fit', 'Location', LegLoc);
    end
    setappdata(handles.TestButton, 'Plot_AFit', PAgingFit);
    setappdata(handles.TestButton, 'Plot_SFit', PSlipFit);
elseif AgingLawFlag == 1 && SlipLawFlag == 0
    if numel(children) > 2
        PAgingTest = getappdata(handles.TestButton, 'Plot_ATest');
        legend(handles.FittingAxes, [PAgingTest, PAgingFit], 'Aging Law Test',...
            'Aging Law Fit', 'Location', LegLoc);
        setappdata(handles.TestButton, 'Plot_AFit', PAgingFit);
    else
        legend(handles.FittingAxes, PAgingFit, 'Aging Law Fit', 'Location',...
            LegLoc);
    end
elseif AgingLawFlag == 0 && SlipLawFlag == 1
    if numel(children) > 2
        PSlipTest = getappdata(handles.TestButton, 'Plot_STest');
        legend(handles.FittingAxes, [PSlipTest, PSlipFit], 'Slip Law Test',...
            'Slip Law Fit', 'Location', LegLoc);
        setappdata(handles.TestButton, 'Plot_SFit', PSlipFit);
    else
        legend(handles.FittingAxes, PSlipFit, 'Slip Law Fit', 'Location',...
            LegLoc);
    end
end    
    
function [x_0, x_e, x_L, NormStress, Slip_ZeroRef, Time_ZeroRef,...
    StateVarFlag, StiffnessFlag, MuFlag, Weight] = GetStuff(handles)

%%% function to get parameter guesses and run flags, set inputs
    
%%% Get parameter guesses, time of step, and step velocity values.
%%% RAS fitting parameters.    
    mu_iString = get(handles.Guess_muValue,'String');
    mu_i = str2double(mu_iString);
    aString = get(handles.Guess_aValue,'String');
    a = str2double(aString);
    bString = get(handles.Guess_bValue,'String');
    b = str2double(bString);
    d_cString = get(handles.Guess_dcValue,'String');
    d_c = str2double(d_cString);
    kString = get(handles.Guess_kValue,'String');
    k = str2double(kString);
    
%%% Check if constraining mu_i and stiffness. MuFlag = 1, fits mu_i. 
%%% MuFlag = 0, does not fit mu_i. StiffnessFlag, same conditions as for 
%%% mu_i.
    StiffnessFlag = getappdata(handles.FitButton, 'StiffnessFlag');
    MuFlag = getappdata(handles.FitButton, 'MuFlag');
    if StiffnessFlag == true && MuFlag == true
        x_0 = [mu_i; a; b; d_c; k];
        x_e = [0; 0];
    elseif StiffnessFlag == true && MuFlag == false
        x_0 = [nan; a; b; d_c; k];
        x_e = [mu_i; 0];
    elseif StiffnessFlag == false && MuFlag == true
        x_0 = [mu_i; a; b; d_c; nan];
        x_e = [0; k];
    else
        x_0 = [nan; a; b; d_c; nan];
        x_e = [mu_i; k];
    end

%%% Check if using two state variables.
    StateVarFlag = getappdata(handles.FitButton, 'StateVarFlag');
    if StateVarFlag
        b2String = get(handles.Guess_b2Value,'String');
        b2 = str2double(b2String);
        d_c2String = get(handles.Guess_dc2Value,'String');
        d_c2 = str2double(d_c2String);
    else
        b2 = 0;
        d_c2 = 0;
    end 
    x_0 = [x_0; b2; d_c2];

%%% Get signal parameters.
    x_L(1,1) = str2double(get(handles.VelocityMean, 'String'));
    x_L(2,1) = str2double(get(handles.VelocityAmp, 'String'));
    x_L(3,1) = 2*pi/str2double(get(handles.SignalPeriod, 'String'));
    x_L(4,1) = str2double(get(handles.SignalPhase, 'String'));
%    x_L = getappdata(handles.DetrendButton, 'SignalParams');
    Slip_ZeroRef = getappdata(handles.DetrendButton,'SlipZeroRef_Data');
    Time_ZeroRef = getappdata(handles.DetrendButton,'TimeZeroRef_Data');
%%% Get the normal stress at beginning of windowed data.
    NormStressZoom = getappdata(handles.SlopeValue, 'NormStressZoomData');
    NormStress = mean(NormStressZoom);
    
%%% Check if fitting a velocity step or a slide-hold-slide.
%    EventFlag = getappdata(handles.FitButton, 'EventFlag');
%    if EventFlag
%%% Velocity step values.
%        InitialVel_String = get(handles.InitialVelocityValue,'String');
%        v_i = str2double(InitialVel_String);
%        FinalVel_String = get(handles.FinalVelocityValue,'String');
%        v_f = str2double(FinalVel_String);
%%% Get time of velocity step by finding the location of the step in the
%%% slip data and pulling out the corresponding time.
%        slip_step = get(handles.StepSlipValue,'String');
%        SlipStep = str2double(slip_step);
%        Slip_ZeroRef = getappdata(handles.DetrendButton,'SlipZeroRef_Data');
%        Time_ZeroRef = getappdata(handles.DetrendButton,'TimeZeroRef_Data');
%        [~, ss] = min(abs(Slip_ZeroRef - SlipStep));
%        TimeOfStep = Time_ZeroRef(ss);
%        Holds{1} = [];
%%% Get the normal stress at the time of the step.
%        NormStressZoom = getappdata(handles.SlopeValue, 'NormStressZoomData');
%        NormStress = NormStressZoom(ss);
%    else
%        Slip_ZeroRef = getappdata(handles.DetrendButton,'SlipZeroRef_Data');
%        Time_ZeroRef = getappdata(handles.DetrendButton,'TimeZeroRef_Data');
%%% Slide-hold-slide values. Load, reload velocities.
%        LoadVel_String = get(handles.LoadVelocityValue,'String');
%        v_i = str2double(LoadVel_String);
%        ReloadVel_String = get(handles.ReloadVelocityValue,'String');
%        v_f = str2double(ReloadVel_String);
%%% Length of hold.
%        HoldTime_String = get(handles.HoldTime,'String');
%        HoldTime = str2double(HoldTime_String);
%%% Time when the hold initiates.
%        TimeOfHold = getappdata(handles.SetHoldButton,'Step_TimeValue');
%        Holds{1} = HoldTime;
%        Holds{2} = TimeOfHold;
%%% Get the normal stress at the time of the hold.
%        NormStress_String = get(handles.LocNormStress,'string');
%        NormStress = str2double(NormStress_String);
%%% Give empty set for TimeOfStep
%        TimeOfStep = [];
%    end
    
%%% Construct weight function.
    WeightFlag = getappdata(handles.FitButton, 'WeightFlag');    
    if WeightFlag    
        [Weight, ~] = WeightCalc(handles);
    else
        N = numel(Slip_ZeroRef);
        Weight = ones(1, N);
        setappdata(handles.WeightLocButton, 'Weight_Function', Weight);
        setappdata(handles.WeightLocButton, 'Weight_Info', nan(3,1));
    end    
    
    
function [x_0,x_f,State1_f,State2_f,Vel_f,Mu_f,Slip_f,SampleSlip_f,exitflag,ODE_Sol,...
    residual,jacobian,resnorm] = RASFittingLD1(x_0,x_e,x_L,NormStress,...
    Mu_Data,LoadPointSlip,Exp_Time,StateLawFlag,StateVarFlag,...
    StiffnessFlag,MuFlag,Weight,SampleSlipFlag,handles)
    
%%% Description of option flags.
%%%     StateLawFlag = true : use the aging law
%%%     StateLawFlag = false : use the slip law
%%%     StateVarFlag = true :  use two state variables
%%%     StateVarFlag = false :  use ones state variable
%%%     EventFlag = true : fitting a velocity step
%%%     EventFlag = false : fitting a slide-hold-slide

%%% Contents of parameter array 'x_0'
%%%     x(1) = mu_0
%%%     x(2) = a;
%%%     x(3) = b1;
%%%     x(4) = d_c1;
%%%     x(5) = k;
%%%     x(6) = b2;
%%%     x(7) = d_c2;
%%%     x(8) = alpha;  

%%% Time steps used for performing fitting simulations and optimization.
%    tSpan = linspace(0,Exp_Time(end),1e3)';
    Period = 2*pi/x_L(3);    
    Time_Eval = 6*Period + Exp_Time;
    tSpan = [0 Time_Eval(end)];
%%% Optimize using nonlinear least squares fitting.
%%% Experimental data that we are fitting.
    Data = [Mu_Data'; LoadPointSlip'];  

%%% Set up objective function where the actual least squares minimization
%%% occurs, see below for description.
%%% Check if a hold time is provided.
%if numel(varargin) == 1
%    HoldTime = varargin{1};
    myObjective = @(x) objFcn(x, x_e, Time_Eval, Data, tSpan, x_L, NormStress,...
        StateLawFlag, StateVarFlag, StiffnessFlag, MuFlag, Weight,...
        SampleSlipFlag);
%else
%    myObjective = @(x) objFcn(x, x_e, Exp_Time, Data, tSpan, v_i, v_amp, NormStress,...
%        Period, StateLawFlag, StateVarFlag, EventFlag,...
%        StiffnessFlag, MuFlag, Weight, SampleSlipFlag);
%end
%%% Options for lsqnonlin.
options = optimoptions(@lsqnonlin,'Display','iter-detailed','Algorithm',...
    'levenberg-marquardt');
%%% Carry out the optimization.
[x_f, resnorm, residual, exitflag, ~, ~, jacobian] = ...
        lsqnonlin(myObjective, x_0, [], [], options);

%%% Run a spring-slider simulation using the fitted parameters contained in
%%% x_f. This will produce numerical friction and slip data that can be
%%% plotted over the experimental data.
a = x_f(2);
b1 = x_f(3);
d_c1 = x_f(4);
b2 = x_f(6);
d_c2 = x_f(7);
if MuFlag == true
    mu_0 = x_f(1);
else
    mu_0 = x_e(1);
end
v_i = x_L(1); 
state1_i = d_c1/v_i;
if StateVarFlag
    state2_i = d_c2/v_i;
    mu_i = mu_0 + a*log(v_i/v_i) + b1*log(v_i*state1_i/d_c1)...
        + b2*log(v_i*state2_i/d_c2);
else
    state2_i = 0;
    mu_i = mu_0 + a*log(v_i/v_i) + b1*log(v_i*state1_i/d_c1);
end
sigma_i = NormStress;
tau_i = mu_i*sigma_i;
slip_i = LoadPointSlip(1);
Vars_i = [state1_i; state2_i; v_i; mu_i; slip_i; sigma_i; tau_i];
opt = odeset('RelTol',1e-9,'AbsTol',[1e-12 1e-12 1e-32 1e-12 1e-12 1e-12 1e-12]);
%if EventFlag
%    ODE_Sol = ode45(@(time,Vars)SpringBlock(time,Vars,x_f,x_e,v_i,v_amp,Period,...
%        StateLawFlag,StateVarFlag,EventFlag,StiffnessFlag,MuFlag),...
%        tSpan,Vars_i,opt);
    
%else
    ODE_Sol = ode15s(@(time,Vars)SpringBlock(time,Vars,x_f,x_e,x_L,StateLawFlag,...
        StateVarFlag,StiffnessFlag,MuFlag), tSpan,Vars_i,opt);
%end

%%% Evaluate the ode solution for the experimental time steps.
bestY = deval(ODE_Sol, Time_Eval);
State1_f = bestY(1,:)';
State2_f = bestY(2,:)';
Vel_f = bestY(3,:)';
Mu_f = bestY(4,:)';
SampleSlip_f = bestY(5,:)';

%%% Compute the load point slip
Slip_f = nan(numel(Exp_Time), 1);
%[~, kk1] = min(abs(Exp_Time - TimeOfStep));
%Slip_f(1:kk1) = v_i*Exp_Time(1:kk1);
%if EventFlag
%    Slip_f(kk1+1:end) = Slip_f(kk1) + v_f*cumsum(diff(Exp_Time(kk1:end)));
%else
%    [~, kk2] = min(abs(Exp_Time - (TimeOfStep + HoldTime)));
%    Slip_f(kk1+1:kk2) = Slip_f(kk1);
%    Slip_f(kk2+1:end) = Slip_f(kk2) + v_f*cumsum(diff(Exp_Time(kk2:end)));
%end


function dVarsdt = SpringBlock(time,Vars,x,x_e,x_L,StateLawFlag,...
    StateVarFlag,StiffnessFlag,MuFlag)
%%% change: v_f = v_amp; TimeOfStep = Period

%%% This function contains the governing equations for a spring slider with
%%% stiffness k. They are cast as coupled ODEs in state variable, friction
%%% coefficient, and slider velocity. There is a fourth ode for slip that
%%% integrates the velocity values. 

%%% RAS parameters.   
    a = x(2);
    b1 = x(3);
    d_c1 = x(4);
    b2 = x(6);
    d_c2 = x(7);
    if StiffnessFlag == true
        k = x(5);
    else
        k = x_e(2);
    end
    
%%% Signal parameters.
    v_L = x_L(1);
    v_amp = x_L(2);
    omega = x_L(3);
    gamma = x_L(4);
    
%%% Simulation variables.
    state1 = Vars(1,1);
    state2 = Vars(2,1);
    vel = Vars(3,1);
    mu = Vars(4,1);
    sigma = Vars(6,1);

%%% Check if a hold time is provided.
%    if numel(varargin) == 1
%        HoldTime = varargin{1};
%    end

%%% Determine which type of event to fit.    
%    if EventFlag
%%% Fit a velcity step.        
%        if time < TimeOfStep 
%            v_L = v_i;
%        else
%            v_L = v_f;
%        end
%    else
%%% Fit a slide-hold-slide
%        if time < TimeOfStep 
%            v_L = v_i;
%        elseif time >= TimeOfStep && time < TimeOfStep + HoldTime
%            v_L = 0;
%        else
%            v_L = v_f;
%        end
%    end

%%% Friction stress.
    v_signal = v_amp*cos(omega*time + gamma);
    dmudt = k*(v_L + v_signal - vel);
%%% Shear stress
    dtaudt = dmudt*sigma;
%%% Normal stress
    dsigmadt = 0;
    
%%% State evolution.    
    if StateLawFlag
%%% Aging Law
        dstate1dt = 1 - state1.*vel./d_c1;
        if StateVarFlag
            dstate2dt = 1 - state2.*vel./d_c2;
        else
            dstate2dt = 0;
        end
    else
%%% Slip Law
        dstate1dt = -(vel.*state1/d_c1).*log(vel.*state1./d_c1);
        if StateVarFlag
            dstate2dt = -(vel.*state2/d_c2).*log(vel.*state2./d_c2);
        else
            dstate2dt = 0;
        end
    end
    
%%% Velocity
    if StateVarFlag
        dveldt = (vel/a).*(dmudt - b1.*dstate1dt./state1...
            - b2.*dstate2dt./state2);
    else
        dveldt = (vel/a).*(dmudt - b1.*dstate1dt./state1);
    end
%%% Sample Displacement
    dslipdt = vel;
    
%%% Create ode vector.    
    dVarsdt = [dstate1dt; dstate2dt; dveldt; dmudt; dslipdt; dsigmadt;...
        dtaudt];

function FitError = objFcn(x, x_e, ExpTime, Data, time, x_L, NormStress,...
    StateLawFlag, StateVarFlag, StiffnessFlag, MuFlag, Weight,...
    SampleSlipFlag)
%%% This is the optimization function that is used to determine the best
%%% fit values for the RAS parameters contained in the vector x. It runs a
%%% spring-slider simulation using the values in x, and attempts to
%%% minimize the difference between the simulated friction coefficient and
%%% slip values and the exerimental data.
    a = x(2);
    b1 = x(3);
    d_c1 = x(4);
    b2 = x(6);
    d_c2 = x(7);
    if StiffnessFlag == true && MuFlag == true
        mu_0 = x(1);
        k = x(5);
    elseif StiffnessFlag == true && MuFlag == false
        mu_0 = x_e(1);
        k = x(5);
    elseif StiffnessFlag == false && MuFlag == true
        mu_0 = x(1);
        k = x_e(2);
    else
        mu_0 = x_e(1);
        k = x_e(2);
    end  

      disp(['mu_0 = ',num2str(mu_0),' ','a = ',num2str(a),' ','b = ',...
          num2str(b1),' ','d_c = ',num2str(d_c1),' ','k = ',num2str(k)])
    
%%% Initial, steady-state conditions for the section of the experiment
%%% being analyzed.
    v_i = x_L(1);
    state1_i = d_c1/v_i;
    if StateVarFlag
        state2_i = d_c2/v_i;
        mu_i = mu_0 + a*log(v_i/v_i) + b1*log(v_i*state1_i/d_c1)...
            + b2*log(v_i*state2_i/d_c2);
    else
        state2_i = 0;
        mu_i = mu_0 + a*log(v_i/v_i) + b1*log(v_i*state1_i/d_c1);
    end
    LoadPointSlip = Data(2,:);
    slip_i = LoadPointSlip(1);
    sigma_i = NormStress;
    tau_i = mu_i*sigma_i;
    Vars_i = [state1_i; state2_i; v_i; mu_i; slip_i; sigma_i; tau_i];
%%% Run the spring-slider simulation.
    opt = odeset('RelTol',1e-9,'AbsTol',...
        [1e-12 1e-12 1e-32 1e-12 1e-12 1e-12 1e-12]);
%%% Check if a hold time is provided.
%    if numel(varargin) == 1
%        HoldTime = varargin{1};
    ODE_Sol = ode15s(@(time,Vars)SpringBlock(time,Vars,x,x_e,x_L,StateLawFlag,...
        StateVarFlag,StiffnessFlag,MuFlag), time,Vars_i,opt);
%    else
%        ODE_Sol = ode45(@(time,Vars)SpringBlock(time,Vars,x,x_e,v_i,v_amp,...
%            Period,StateLawFlag,StateVarFlag,EventFlag,...
%            StiffnessFlag,MuFlag), time,Vars_i,opt);
%    end
    if ODE_Sol.x(end) < time(end)
        if b2 == 0
            ME = MException('ODE:fail',...
                ['ODE solver has failed at parameter values:' char(10) 'mu_0 = %.4f, a = %f, b_1 = %f, d_c1 = %.2f, k = %f'],...
                mu_0, a, b1, d_c1, k);
        else
            ME = MException('ODE:fail',...
                ['ODE solver has failed at parameter values:' char(10) 'mu_0 = %.4f, a = %f, b_1 = %f, b_2 = %f, d_c1 = %.2f, d_c2 = %.2f, k = %f'],...
                mu_0, a, b1, b2, d_c1, d_c2, k);
        end
        throw(ME)
%%% Evaluate the solution structure at the experimental time values.
    else
        simY = deval(ODE_Sol, ExpTime);
    end

%%% Fit based on minimizing friction coefficient.
    FitError = simY(4,:) - Data(1,:);
    FitError = Weight.*FitError;

    
% --- Executes on button press in CreateStructureButton.
function CreateStructureButton_Callback(hObject, eventdata, handles)
% hObject    handle to CreateStructureButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Check Flags.
%    EventFlag = getappdata(handles.FitButton, 'EventFlag');
    StiffnessFlag = getappdata(handles.FitButton, 'StiffnessFlag');
    MuFlag = getappdata(handles.FitButton, 'MuFlag');
    StateVarFlag = getappdata(handles.FitButton, 'StateVarFlag');
    WeightFlag = getappdata(handles.FitButton, 'WeightFlag');
%%% Check what fits were done.
    AgingLawFlag = getappdata(handles.FitButton, 'AgingLawFlag');
    SlipLawFlag = getappdata(handles.FitButton, 'SlipLawFlag');        
%%% Get all of the data and parameters and save them in a structure named
%%% after the entry in the "Fit Tag" field.
%%% Read the detrending point locations from their text boxes.
    Point1_SlipString = get(handles.Point1SlipValue,'String');
    Point1_FrictionString = get(handles.Point1MuValue,'String');
    Point2_SlipString = get(handles.Point2SlipValue,'String');
    Point2_FrictionString = get(handles.Point2MuValue,'String');
    Point1_Slip = str2double(Point1_SlipString);
    Point1_Friction = str2double(Point1_FrictionString);
    Point2_Slip = str2double(Point2_SlipString);
    Point2_Friction = str2double(Point2_FrictionString);
%%% Read the detrending reference point.
    ReferencePoint_TimeString = get(handles.ReferencePointSlipValue,'String');
    ReferencePoint_FrictionString = get(handles.ReferencePointMuValue,'String');
    ReferencePoint_Time = str2double(ReferencePoint_TimeString);
    ReferencePoint_Friction = str2double(ReferencePoint_FrictionString);
%%% Read linear fit slope value from text box.
    m_String = get(handles.SlopeValue,'String');
    m = str2double(m_String);    
%%% Get the stored zoomed slip and friction data and reference slip.
    SlipZoom = getappdata(handles.SlopeValue,'SlipZoom_Data');
    FrictionZoom = getappdata(handles.SlopeValue,'FrictionZoom_Data');
    Friction_Detrend = getappdata(handles.DetrendButton,'FrictionDetrend_Data');
    TimeZoom = getappdata(handles.SlopeValue,'TimeZoom_Data'); 
    NormalStressZoom = getappdata(handles.SlopeValue, 'NormStressZoomData');
%%% Get parameter guesses, fitted parameters, fitted data.
    x_0 = getappdata(handles.FitButton,'X0');
    x_fAging = getappdata(handles.FitButton,'XF_Aging');
    AgingError = getappdata(handles.FitButton, 'AgingErrors');
    x_fSlip = getappdata(handles.FitButton,'XF_Slip');
    SlipError = getappdata(handles.FitButton, 'SlipErrors');
    Slip_fAging = getappdata(handles.FitButton,'SlipFit_Aging');
    Mu_fAging = getappdata(handles.FitButton,'FrictionFit_Aging');
    Slip_fSlip = getappdata(handles.FitButton,'SlipFit_Slip');
    Mu_fSlip = getappdata(handles.FitButton,'FrictionFit_Slip');
%%% Velocity signal parameters
    x_L = getappdata(handles.DetrendButton, 'SignalParams');
%%% Get the load point slip fit.
    Slip_LFit = getappdata(handles.DetrendButton, 'SignalSlipFit');
%%% Get the normal stress at the time of the step.
    NormStress = getappdata(handles.FitButton, 'NormStressStep');
%%% Get the weight information.
    Weight = getappdata(handles.WeightLocButton, 'Weight_Function')';
    WeightParameters = getappdata(handles.WeightLocButton, 'Weight_Info');
    if WeightFlag    
        slip_weight = get(handles.WeightSlipValue, 'String');    
        WeightSlip = str2double(slip_weight);
        friction_weight = get(handles.WeightFrictionValue, 'String');
        WeightFriction = str2double(friction_weight);
    else
        WeightSlip = [];
        WeightFriction = [];
    end
%%% Get the exit flags and residuals
    ExitFlags = getappdata(handles.FitButton, 'ExitFlag');
    FrictionVariability = sum((Friction_Detrend - mean(Friction_Detrend)).^2);
    if AgingLawFlag == 1 && SlipLawFlag == 1
        ExitAging = ExitFlags(1, 1);
        ExitSlip = ExitFlags(2, 1);
        FrictionResidualA = sum((Mu_fAging - Friction_Detrend).^2);
        FrictionResidualS = sum((Mu_fSlip - Friction_Detrend).^2);
        FrictionCOD_A = 1 - FrictionResidualA/FrictionVariability;
        FrictionCOD_S = 1 - FrictionResidualS/FrictionVariability;
    elseif AgingLawFlag == 1
        ExitAging = ExitFlags(1, 1);
        FrictionResidualA = sum((Mu_fAging - Friction_Detrend).^2);
        FrictionCOD_A = 1 - FrictionResidualA/FrictionVariability;
    elseif SlipLawFlag == 1
        ExitSlip = ExitFlags(1, 1);
        FrictionResidualS = sum((Mu_fSlip - Friction_Detrend).^2);
        FrictionCOD_S = 1 - FrictionResidualS/FrictionVariability;
    end

%%% Create the structure and store the data.            
    if AgingLawFlag == 1
        if m == 0
            AgingFitData = [Slip_LFit, Mu_fAging];
        else
            Mu_fAging_Retrend = Mu_fAging - m*(ReferencePoint_Time...
                - TimeZoom);
            AgingFitData = [Slip_LFit, Mu_fAging, Mu_fAging_Retrend];
        end
    else
        AgingFitData = [ ];
    end
    if SlipLawFlag == 1
        if m == 0
            SlipFitData = [Slip_LFit, Mu_fSlip];
        else
            Mu_fSlip_Retrend = Mu_fSlip - m*(ReferencePoint_Time...
                - TimeZoom);
            SlipFitData = [Slip_LFit, Mu_fSlip, Mu_fSlip_Retrend];
        end
    else            
        SlipFitData = [ ];
    end

    StepData = struct('LoadPointDisplacementData', SlipZoom, 'FrictionData', FrictionZoom,...
        'FrictionDataDetrended', Friction_Detrend, 'TimeData', TimeZoom,...
        'NormalStressData', NormalStressZoom, 'DetrendParameters', [],...
        'FittingOptions', [], 'SignalParameters', [], 'TrialParameters', [],...
        'AgingLawParameters', [], 'SlipLawParameters', [], 'AgingLawFit',...
        AgingFitData, 'SlipLawFit', SlipFitData, 'WeightInfo', []);

    StepData.SignalParameters = struct('MeanVelocity',x_L(1),...
        'SignalAmplitude', x_L(2), 'SignalPeriod', 2*pi/x_L(3),...
        'SignalPhase', x_L(4), 'NormalStress', NormStress, 'TimeOfEvent',...
        TimeZoom(1));
    
    StepData.DetrendParameters = struct('Point1', [Point1_Slip, Point1_Friction],...
        'Point2', [Point2_Slip, Point2_Friction], 'ReferencePoint',...
        [ReferencePoint_Time, ReferencePoint_Friction], 'Slope', m);
    if StateVarFlag
        OptionS = 'true';
    else
        OptionS = 'false';
    end
    if MuFlag
        OptionMu = 'false';
    else
        OptionMu = 'true';
    end
    if StiffnessFlag
        OptionK = 'false';
    else
        OptionK = 'true';
    end
    if WeightFlag
        OptionW = 'true';
    else
        OptionW = 'false';
    end
    StepData.FittingOptions = struct('UseTwoStateVariables', OptionS,...
        'ConstrainMu_0', OptionMu, 'ConstrainStiffness', OptionK,...
        'UseWeightFunction', OptionW);
       
    StepData.WeightInfo = struct('Weights', Weight, 'N', WeightParameters(1),...
        'i_w', WeightParameters(2), 'p', WeightParameters(3), 'WeightLocation',...
        [WeightSlip, WeightFriction]);
%%% Get parameter guesses, time of step, and step velocity values.
%%% RAS fitting parameters.    
    mu_iString = get(handles.Guess_muValue,'String');
    mu_i = str2double(mu_iString);
    aString = get(handles.Guess_aValue,'String');
    a = str2double(aString);
    bString = get(handles.Guess_bValue,'String');
    b = str2double(bString);
    d_cString = get(handles.Guess_dcValue,'String');
    d_c = str2double(d_cString);
    kString = get(handles.Guess_kValue,'String');
    k = str2double(kString);    
    
    StepData.TrialParameters = struct('mu_0', mu_i, 'a', a, 'b1',...
        b, 'b2', x_0(6), 'd_c1', d_c, 'd_c2', x_0(7), 'stiffness', k);
    
if isempty(x_fAging)
    StepData.AgingLawParameters = [ ];
else
    CovarA = getappdata(handles.FitButton,'CovarianceA');
    StepData.AgingLawParameters = struct('mu_0', [x_fAging(1), AgingError(1)],...
        'a', [x_fAging(2), AgingError(2)], 'b1', [x_fAging(3), AgingError(3)],...
        'b2', [x_fAging(6), AgingError(4)], 'aminusb', [x_fAging(2) - x_fAging(3)...
        - x_fAging(6), AgingError(8)], 'd_c1', [x_fAging(4), AgingError(5)],...
        'd_c2', [x_fAging(7), AgingError(6)], 'stiffness', [x_fAging(5),...
        AgingError(7)], 'ExitFlag', ExitAging, 'R_Squared', FrictionCOD_A,...
        'CovarianceMatrix', CovarA);
end
    
if isempty(x_fSlip)
    StepData.SlipLawParameters = [ ];
else
    CovarS = getappdata(handles.FitButton,'CovarianceS');
    StepData.SlipLawParameters = struct('mu_0', [x_fSlip(1), SlipError(1)],...
        'a', [x_fSlip(2), SlipError(2)], 'b1', [x_fSlip(3), SlipError(3)],...
        'b2', [x_fSlip(6), SlipError(4)], 'aminusb', [x_fSlip(2) - x_fSlip(3)...
        - x_fSlip(6), SlipError(8)], 'd_c1', [x_fSlip(4), SlipError(5)],...
        'd_c2', [x_fSlip(7), SlipError(6)], 'stiffness', [x_fSlip(5),...
        SlipError(7)], 'ExitFlag', ExitSlip, 'R_Squared', FrictionCOD_S,...
        'CovarianceMatrix', CovarS);
end
    
%%% Save the structure to the workspace.
    StuctureName = get(handles.FitTagName,'String');
    assignin('base',StuctureName,StepData);

function FitTagName_Callback(hObject, eventdata, handles)
% hObject    handle to FitTagName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FitTagName as text
%        str2double(get(hObject,'String')) returns contents of FitTagName as a double


% --- Executes during object creation, after setting all properties.
function FitTagName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FitTagName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgingFit_muValue_Callback(hObject, eventdata, handles)
% hObject    handle to AgingFit_muValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgingFit_muValue as text
%        str2double(get(hObject,'String')) returns contents of AgingFit_muValue as a double


% --- Executes during object creation, after setting all properties.
function AgingFit_muValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgingFit_muValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgingFit_aValue_Callback(hObject, eventdata, handles)
% hObject    handle to AgingFit_aValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgingFit_aValue as text
%        str2double(get(hObject,'String')) returns contents of AgingFit_aValue as a double


% --- Executes during object creation, after setting all properties.
function AgingFit_aValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgingFit_aValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgingFit_bValue_Callback(hObject, eventdata, handles)
% hObject    handle to AgingFit_bValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgingFit_bValue as text
%        str2double(get(hObject,'String')) returns contents of AgingFit_bValue as a double


% --- Executes during object creation, after setting all properties.
function AgingFit_bValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgingFit_bValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgingFit_dcValue_Callback(hObject, eventdata, handles)
% hObject    handle to AgingFit_dcValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgingFit_dcValue as text
%        str2double(get(hObject,'String')) returns contents of AgingFit_dcValue as a double


% --- Executes during object creation, after setting all properties.
function AgingFit_dcValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgingFit_dcValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgingFit_kValue_Callback(hObject, eventdata, handles)
% hObject    handle to AgingFit_kValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgingFit_kValue as text
%        str2double(get(hObject,'String')) returns contents of AgingFit_kValue as a double


% --- Executes during object creation, after setting all properties.
function AgingFit_kValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgingFit_kValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StepFrictionValue_Callback(hObject, eventdata, handles)
% hObject    handle to StepFrictionValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StepFrictionValue as text
%        str2double(get(hObject,'String')) returns contents of StepFrictionValue as a double


% --- Executes during object creation, after setting all properties.
function StepFrictionValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StepFrictionValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function InitialVelocityValue_Callback(hObject, eventdata, handles)
% hObject    handle to InitialVelocityValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InitialVelocityValue as text
%        str2double(get(hObject,'String')) returns contents of InitialVelocityValue as a double


% --- Executes during object creation, after setting all properties.
function InitialVelocityValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InitialVelocityValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FinalVelocityValue_Callback(hObject, eventdata, handles)
% hObject    handle to FinalVelocityValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FinalVelocityValue as text
%        str2double(get(hObject,'String')) returns contents of FinalVelocityValue as a double


% --- Executes during object creation, after setting all properties.
function FinalVelocityValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FinalVelocityValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TwoStateButton.
function TwoStateButton_Callback(hObject, eventdata, handles)
% hObject    handle to TwoStateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Get the status of the evolution law buttons button.
AgingLawFlag = getappdata(handles.FitButton, 'AgingLawFlag');
SlipLawFlag = getappdata(handles.FitButton, 'SlipLawFlag');

if (get(hObject,'Value') == get(hObject,'Max'))
%%% Button is selected, enable the additional state variable fields, and
%%% set the two state variable flag to "true".
    setappdata(handles.FitButton, 'StateVarFlag', true);
    set(handles.Guess_b2Value, 'Enable', 'on')
    set(handles.Guess_dc2Value, 'Enable', 'on')
    if AgingLawFlag
        set(handles.AgingFit_b2Value, 'Enable', 'on')
        set(handles.AgingFit_dc2Value, 'Enable', 'on')
    end
    if SlipLawFlag
        set(handles.SlipFit_b2Value, 'Enable', 'on')        
        set(handles.SlipFit_dc2Value, 'Enable', 'on')
    end
else
%%% Button is not selected, disable the additional state variable fields,
%%% and set the two state variable flag to "false".
    setappdata(handles.FitButton, 'StateVarFlag', false);
    set(handles.Guess_b2Value, 'Enable', 'off')
    set(handles.AgingFit_b2Value, 'Enable', 'off')
    set(handles.SlipFit_b2Value, 'Enable', 'off')
    set(handles.Guess_dc2Value, 'Enable', 'off')
    set(handles.AgingFit_dc2Value, 'Enable', 'off')
    set(handles.SlipFit_dc2Value, 'Enable', 'off')
end



% --- Executes on button press in SlipLawButton.
function SlipLawButton_Callback(hObject, eventdata, handles)
% hObject    handle to SlipLawButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SlipLawButton



function Point1SlipValue_Callback(hObject, eventdata, handles)
% hObject    handle to Point1SlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Point1SlipValue as text
%        str2double(get(hObject,'String')) returns contents of Point1SlipValue as a double


% --- Executes during object creation, after setting all properties.
function Point1SlipValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Point1SlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Point2Values_Callback(hObject, eventdata, handles)
% hObject    handle to Point2Values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Point2Values as text
%        str2double(get(hObject,'String')) returns contents of Point2Values as a double


% --- Executes during object creation, after setting all properties.
function Point2Values_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Point2Values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DetrendButton.
function DetrendButton_Callback(hObject, eventdata, handles)
% hObject    handle to DetrendButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Get the slip, friction, normal stress, and time data.
    SlipData = getappdata(handles.SlipDataName, 'Slip_Data');
    FrictionData = getappdata(handles.FrictionDataName, 'Friction_Data');
    TimeData = getappdata(handles.TimeDataName, 'Time_Data');
    NormStressData = getappdata(handles.P_cDataName, 'NormStress_Data');    
%%% Determine the slip and friction data from only the visible portion of 
%%% the main axes.    
    XLimZoom = get(handles.MainAxes,'XLim');    
    [~, i] = min(abs(TimeData - XLimZoom(1)));
    [~, ii] = min(abs(TimeData - XLimZoom(2)));
    SlipZoom = SlipData(i:ii);
    FrictionZoom = FrictionData(i:ii);
    TimeZoom = TimeData(i:ii);
    NormStressZoom = NormStressData(i:ii);
%%% Read linear fit latex_slope value from text box, in case it has been manually
%%% entered.
    m_String = get(handles.SlopeValue,'String');
    m = str2double(m_String);
%%% Get the reference slip value for detrending, use the value from the
%%% picked reference point.  
    Time_Ref_String = get(handles.ReferencePointSlipValue, 'String');
    Time_Reference = str2double(Time_Ref_String);
%%% Detrend, reference to zero, and plot in fitting axes.
    if m == 0
        Friction_Detrend = FrictionZoom;
    else
        Friction_Detrend = FrictionZoom + m*(Time_Reference - TimeZoom);
    end
    Slip_ZeroRef = SlipZoom - SlipZoom(1);
    Time_ZeroRef = TimeZoom - TimeZoom(1);
%%% Plot detrended data in Fitting Axes.
    plot(handles.FittingAxes,Time_ZeroRef,Friction_Detrend,'k.');
    xlabel(handles.FittingAxes,'Time (s)');
    ylabel(handles.FittingAxes,'Friction Coefficient');
%%% Store the zero-referenced data.
    setappdata(handles.DetrendButton,'FrictionDetrend_Data',Friction_Detrend);
    setappdata(handles.DetrendButton,'SlipZeroRef_Data',Slip_ZeroRef);
    setappdata(handles.DetrendButton,'TimeZeroRef_Data',Time_ZeroRef);
    setappdata(handles.SlopeValue,'SlipZoom_Data',SlipZoom);
    setappdata(handles.SlopeValue,'FrictionZoom_Data',FrictionZoom);
    setappdata(handles.SlopeValue,'TimeZoom_Data',TimeZoom);
    setappdata(handles.SlopeValue, 'NormStressZoomData', NormStressZoom);
    set(handles.LocNormStress, 'String', num2str(mean(NormStressZoom)));
%%% Determine the load point velocity signal parameters.
%    x_L(1) = v_m
%    x_L(2) = v_a
%    x_L(3) = omega; T = 2*pi/omega
%    x_L(4) = gamma
    [x_L, Slip_LFit] = SignalFit(Time_ZeroRef, Slip_ZeroRef);
    setappdata(handles.DetrendButton, 'SignalParams', x_L);
    setappdata(handles.DetrendButton, 'SignalSlipFit', Slip_LFit);
%%% Display the signal parameter values.
    set(handles.VelocityMean, 'String', num2str(x_L(1)));
    set(handles.VelocityAmp, 'String', num2str(x_L(2)));
    set(handles.SignalPeriod, 'String', num2str(2*pi/x_L(3)));
    set(handles.SignalPhase, 'String', num2str(x_L(4)));
%%% Display the parameters and plot the results.
    figure; plot(Time_ZeroRef, Slip_ZeroRef, 'ko', Time_ZeroRef, Slip_LFit,...
        'c', 'LineWidth', 2)
    xlabel('Time (s)');
    ylabel('Load Point Slip (\mum)');
    title(['v_m = ', num2str(round(x_L(1),1)), ' \mum/s, v_a = ',...
        num2str(round(x_L(2),1)), ' \mum/s, T = ', num2str(round(2*pi/x_L(3),1)),...
        ' s, \gamma = ', num2str(round(x_L(4),1)), ' rad, \sigma = ',...
        num2str(round(mean(NormStressZoom))), ' kPa']);

    
function [x_L, Slip_LFit] = SignalFit(Time_0, Slip_0)
%%% This is a crude estimate that could probably be replaced by more 
%%% rigorous signal analysis. However, since ultimately the signal
%%% parameters are determined by the non-linear fitting routine, it is not
%%% essential.
%%% Compute the load point velocity. Smooth the load point velocity using a
%%% moving average with a window size based off of the sampling frequency
%%% and total time of the data.
%    W = 100;
%    Vel_L = gradient(movmean(Slip_0,W))./gradient(Time_0);
%    Vel_Lcut = Vel_L(0.6*W:end-0.6*W);
%%% Estimate the signal parameters.
%    v_a = (max(Vel_Lcut) - min(Vel_Lcut))/2;
%    v_m = min(Vel_Lcut) + v_a;
%%% Estimate the period.
%    W = 4000;
%    W = round(numel(Time_0)/10);
%    Vel_L = gradient(movmean(Slip_0,W))./gradient(Time_0);
%    Vel_Lcut = Vel_L(0.6*W:end-0.6*W);
%    Time_0cut = Time_0(0.6*W:end-0.6*W);
%    [pks, locs, ~, p] = findpeaks(Vel_Lcut, Time_0cut, 'MinPeakDistance',...
%        Time_0(end)/(4*2));
%    ip = pks > v_a;
%    Period = mean(diff(locs(ip)));
    
    dt = mean(diff(Time_0));
    Slip_S = detrend(Slip_0);
    Corr_Slip = xcorr(Slip_S,Slip_S);
    [ts, locs] = findpeaks(movmean(Corr_Slip, 100));
%    [ts, locs] = findpeaks(movmean(Corr_Slip, 100), 'MinPeakDistance',...
%        mean(diff(locs(ts > 0))));
    Period = mean(diff(locs(2:end-1)))*dt;
%    Period = mean(diff(locs(ts > 0)))*dt;
    [pks_s, locs_s] = findpeaks(Slip_S, Time_0, 'MinPeakDistance', 0.9*Period);
    slip_a = mean(pks_s);
    p = polyfit(Time_0,Slip_0,1);
    v_m = p(1);
    v_a = 2*pi*slip_a/Period;
    
    x0 = [v_m; v_a; 2*pi/Period; 2*pi*(Period/4 - locs_s(1))/Period];
%%%% Fit the load point slip data.
%    x(1) = v_m
%    x(2) = v_a
%    x(3) = omega; T = 2*pi/omega
%    x(4) = gamma
    F = @(x, time_data) x(1)*time_data + (x(2)/x(3))*sin(x(3)*time_data + x(4)) - (x(2)/x(3))*sin(x(4));
    [x_L, ~, ~, ~, ~] = lsqcurvefit(F, x0, Time_0, Slip_0);
    x_L(4) = mod(x_L(4), 2*pi);
    Slip_LFit = x_L(1)*Time_0 + (x_L(2)/x_L(3))*sin(x_L(3)*Time_0 + x_L(4))...
        - (x_L(2)/x_L(3))*sin(x_L(4));
    

% --- Executes on button press in NoTrendButton.
function NoTrendButton_Callback(hObject, eventdata, handles)
% hObject    handle to NoTrendButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function SlopeValue_Callback(hObject, eventdata, handles)
% hObject    handle to SlopeValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlopeValue as text
%        str2double(get(hObject,'String')) returns contents of SlopeValue as a double


% --- Executes during object creation, after setting all properties.
function SlopeValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlopeValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ResetPlotButton.
function ResetPlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetPlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlotButton.
function PlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Get the data from the workspace.
    SlipDataString = get(handles.SlipDataName, 'String');
    SlipData = evalin('base', SlipDataString); 
    FrictionDataString = get(handles.FrictionDataName, 'String');
    FrictionData = evalin('base', FrictionDataString);
    TimeDataString = get(handles.TimeDataName, 'String');
    TimeData = evalin('base', TimeDataString);
    NormStressDataString = get(handles.P_cDataName, 'String');
    NormStressData = evalin('base', NormStressDataString);
%%% Check orientation of vectors.
    if size(SlipData,1) == 1
        SlipData = SlipData';
    end
    if size(FrictionData,1) == 1
        FrictionData = FrictionData';
    end
    if size(TimeData,1) == 1
        TimeData = TimeData';
    end
    if size(NormStressData,1) == 1
        NormStressData = NormStressData';
    end
%%% Check if using sample slip data.
    SampleSlipFlag = getappdata(handles.FitButton, 'SampleSlipFlag');
    if SampleSlipFlag
        SampleSlipDataString = get(handles.SampleSlipDataName, 'String');
        SampleSlipData = evalin('base', SampleSlipDataString);
        setappdata(handles.SampleSlipDataName, 'SampleSlip_Data', SampleSlipData);
    end
%%% Plot the time and friction data on the main axes and the static axes.
    plot(handles.MainAxes, TimeData, FrictionData, 'k.');
    set(handles.MainAxes, 'ButtonDownFcn', {@MainAxes_ButtonDownFcn, handles},...
        'HitTest', 'on');
    xlabel(handles.MainAxes,'Time (s)');
    ylabel(handles.MainAxes,'Friction Coefficient');
    Main_ylim = ylim(handles.MainAxes);
    if Main_ylim(1) < 0
        Main_ylim = [0 Main_ylim(2)];
        ylim(handles.MainAxes,Main_ylim);
    end
    children = get(handles.StaticAxes, 'children');
    delete(children);
    hold(handles.StaticAxes, 'off');
    plot(handles.StaticAxes,TimeData,FrictionData,'k.');
    hold(handles.StaticAxes, 'on');
    xlabel(handles.StaticAxes,'Time (s)');
    ylabel(handles.StaticAxes,'Friction Coefficient');
	ylim(handles.StaticAxes,Main_ylim);
%%% Store the data for use in other callback functions.
    setappdata(handles.SlipDataName, 'Slip_Data', SlipData);
    setappdata(handles.FrictionDataName, 'Friction_Data', FrictionData);
    setappdata(handles.TimeDataName, 'Time_Data', TimeData);
    setappdata(handles.P_cDataName, 'NormStress_Data', NormStressData);

function SlipDataName_Callback(hObject, eventdata, handles)
% hObject    handle to SlipDataName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipDataName as text
%        str2double(get(hObject,'String')) returns contents of SlipDataName as a double
%SlipDataString = get(hObject,'String');
%SlipData = evalin('base',SlipDataString); 

% --- Executes during object creation, after setting all properties.
function SlipDataName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipDataName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FrictionDataName_Callback(hObject, eventdata, handles)
% hObject    handle to FrictionDataName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrictionDataName as text
%        str2double(get(hObject,'String')) returns contents of FrictionDataName as a double

%FrictionDataString = get(hObject,'String');
%FrictionData = evalin('base',FrictionDataString); 

% --- Executes during object creation, after setting all properties.
function FrictionDataName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrictionDataName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetPoint1Button.
function SetPoint1Button_Callback(hObject, eventdata, handles)
% hObject    handle to SetPoint1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Set the data point to be recorded when the left mouse button is
%%% clicked.
    datacursormode on
    waitforbuttonpress
    cursorMode = datacursormode(gcf);
    dcm_Info = getCursorInfo(cursorMode);
    Position = dcm_Info.Position;
    datacursormode off
    set(handles.Point1SlipValue, 'String', num2str(Position(1)));
    set(handles.Point1MuValue, 'String', num2str(Position(2)));  

    
% --- Executes on button press in SetPoint2Button.
function SetPoint2Button_Callback(hObject, eventdata, handles)
% hObject    handle to SetPoint2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Set the data point to be recorded when the left mouse button is
%%% clicked.
    datacursormode on
    waitforbuttonpress
    cursorMode = datacursormode(gcf);
    dcm_Info = getCursorInfo(cursorMode);
    Position = dcm_Info.Position;
    datacursormode off
    set(handles.Point2SlipValue, 'String', num2str(Position(1)));
    set(handles.Point2MuValue, 'String', num2str(Position(2)));

function Point2SlipValue_Callback(hObject, eventdata, handles)
% hObject    handle to Point2SlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Point2SlipValue as text
%        str2double(get(hObject,'String')) returns contents of Point2SlipValue as a double


% --- Executes during object creation, after setting all properties.
function Point2SlipValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Point2SlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Point1MuValue_Callback(hObject, eventdata, handles)
% hObject    handle to Point1MuValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Point1MuValue as text
%        str2double(get(hObject,'String')) returns contents of Point1MuValue as a double


% --- Executes during object creation, after setting all properties.
function Point1MuValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Point1MuValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Point2MuValue_Callback(hObject, eventdata, handles)
% hObject    handle to Point2MuValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Point2MuValue as text
%        str2double(get(hObject,'String')) returns contents of Point2MuValue as a double


% --- Executes during object creation, after setting all properties.
function Point2MuValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Point2MuValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FitTrendButton.
function FitTrendButton_Callback(hObject, eventdata, handles)
% hObject    handle to FitTrendButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Get the point locations.
    Point1_TimeString = get(handles.Point1SlipValue,'String');
    Point2_TimeString = get(handles.Point2SlipValue,'String');
    Point1_Time = str2double(Point1_TimeString);
    Point2_Time = str2double(Point2_TimeString);
%%% Get the slip, friction, and time data.
    SlipData = getappdata(handles.SlipDataName,'Slip_Data');
    FrictionData = getappdata(handles.FrictionDataName,'Friction_Data');
    TimeData = getappdata(handles.TimeDataName,'Time_Data');
%%% Determine the slip and friction data from only the visible portion of 
%%% the main axes.    
    XLimZoom = get(handles.MainAxes,'XLim');
    [~, i] = min(abs(TimeData - XLimZoom(1)));
    [~, ii] = min(abs(TimeData - XLimZoom(2)));
    SlipZoom = SlipData(i:ii);
    FrictionZoom = FrictionData(i:ii);
    TimeZoom = TimeData(i:ii);
%%% Determine the section of the data to fit the linear trend from the
%%% locations of the set points.
    [~, i] = min(abs(TimeZoom - Point1_Time));
    [~, ii] = min(abs(TimeZoom - Point2_Time));
%%% See if there is a previous detrend line plotted and delete it.
    children = get(handles.MainAxes, 'children');
    if numel(children) > 1
        delete(children(1:end-1));
    end        
%%% Do the linear fit and plot the line on the main axes.
    p = polyfit(TimeZoom(i:ii),FrictionZoom(i:ii),1);
    hold(handles.MainAxes,'on');
    plot(handles.MainAxes,TimeZoom,p(1)*TimeZoom + p(2),'r')
    hold(handles.MainAxes,'off');
%%% Display the latex_slope value in the GUI latex_slope box.
    set(handles.SlopeValue, 'String', num2str(p(1)));
%%% Store the zoomed slip and friction values, and the linear fit latex_slope
%%% value.
    setappdata(handles.SlopeValue,'SlipZoom_Data',SlipZoom);
    setappdata(handles.SlopeValue,'FrictionZoom_Data',FrictionZoom);
    setappdata(handles.SlopeValue,'TimeZoom_Data',TimeZoom);
    setappdata(handles.SlopeValue,'Slope_Value',p(1));


% --- Executes on button press in SetVelocityStepButton.
function SetVelocityStepButton_Callback(hObject, eventdata, handles)
% hObject    handle to SetVelocityStepButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Set the data point to be recorded when the left mouse button is
%%% clicked.
    datacursormode on
    waitforbuttonpress
    cursorMode = datacursormode(gcf);
    dcm_Info = getCursorInfo(cursorMode);
    Position = dcm_Info.Position;
    datacursormode off
    set(handles.StepSlipValue, 'String', num2str(Position(1)));
    set(handles.StepFrictionValue, 'String', num2str(Position(2)));
%%% Store slip value for detrending later.
    setappdata(handles.StepSlipValue,'Step_SlipValue',Position(1));
    setappdata(handles.StepFrictionValue,'Step_SlipValue',Position(2));
%%% Compute sliding velocities before and after the step, using the
%%% windowed data.
    Slip_ZeroRef = getappdata(handles.DetrendButton,'SlipZeroRef_Data');
    Time_ZeroRef = getappdata(handles.DetrendButton,'TimeZeroRef_Data');
    [~, kk] = min(abs(Slip_ZeroRef - Position(1)));
    v_i = Slip_ZeroRef(kk)/Time_ZeroRef(kk);
    v_f = (Slip_ZeroRef(end) - Slip_ZeroRef(kk))...
        /(Time_ZeroRef(end) - Time_ZeroRef(kk));
%%% Plot the displacement time series for the windowed data, showing the
%%% location of the selected step.
    figure;plot(Time_ZeroRef, Slip_ZeroRef, 'k.', Time_ZeroRef(kk),Position(1),...
        'ro','MarkerFaceColor','r')
    xlabel('Time (s)')
    ylabel('Load Point Displacement (\mum)')        
%%% Store velocity values and display in the GUI.
    set(handles.InitialVelocityValue,'String', num2str(v_i));
    set(handles.FinalVelocityValue,'String', num2str(v_f));
%%% Find the normal stress at time of step an display.
    NormStressZoom = getappdata(handles.SlopeValue, 'NormStressZoomData');
    NormStress = NormStressZoom(kk);
    set(handles.LocNormStress, 'String', num2str(NormStress));

function StepSlipValue_Callback(hObject, eventdata, handles)
% hObject    handle to StepSlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StepSlipValue as text
%        str2double(get(hObject,'String')) returns contents of StepSlipValue as a double


% --- Executes during object creation, after setting all properties.
function StepSlipValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StepSlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TimeDataName_Callback(hObject, eventdata, handles)
% hObject    handle to TimeDataName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeDataName as text
%        str2double(get(hObject,'String')) returns contents of TimeDataName as a double


% --- Executes during object creation, after setting all properties.
function TimeDataName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeDataName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HoldSlipValue_Callback(hObject, eventdata, handles)
% hObject    handle to HoldSlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HoldSlipValue as text
%        str2double(get(hObject,'String')) returns contents of HoldSlipValue as a double


% --- Executes during object creation, after setting all properties.
function HoldSlipValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HoldSlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetHoldButton.
function SetHoldButton_Callback(hObject, eventdata, handles)
% hObject    handle to SetHoldButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Plot the detrended friction data against zero referenced time.
    Time_ZeroRef = getappdata(handles.DetrendButton,'TimeZeroRef_Data');
    Slip_ZeroRef = getappdata(handles.DetrendButton,'SlipZeroRef_Data');
%%% Set the data point to be recorded when the left mouse button is
%%% clicked.
    datacursormode on
    waitforbuttonpress
    cursorMode = datacursormode(gcf);
    dcm_Info = getCursorInfo(cursorMode);
    Position = dcm_Info.Position;
    datacursormode off
%%% Find the zero reference slip value corresponding to the selected time.
    [~, ii] = min(abs(Time_ZeroRef - Position(1)));
    HoldSlip = Slip_ZeroRef(ii);
%%% Plot the displacement time series for the windowed data, showing the
%%% location of the selected hold
    figure;plot(Time_ZeroRef, Slip_ZeroRef, 'k.', Position(1), Slip_ZeroRef(ii),...
        'ro','MarkerFaceColor','r')
    xlabel('Time (s)')
    ylabel('Load Point Displacement (\mum)')      
%%% Display the values in the SHS Parameters panel    
    set(handles.HoldSlipValue, 'String', num2str(Position(1)));
    set(handles.HoldFrictionValue, 'String', num2str(Position(2)));
%%% Store values and the plot handle.
    setappdata(handles.SetHoldButton,'Step_TimeValue',Position(1));
    setappdata(handles.HoldSlipValue,'Step_SlipValue',HoldSlip);
    setappdata(handles.HoldFrictionValue,'Step_FrictionValue',Position(2));
%%% Find the normal stress at time of step an display.
    NormStressZoom = getappdata(handles.SlopeValue, 'NormStressZoomData');
    NormStress = NormStressZoom(ii);
    set(handles.LocNormStress, 'String', num2str(NormStress));

function ReloadVelocityValue_Callback(hObject, eventdata, handles)
% hObject    handle to ReloadVelocityValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ReloadVelocityValue as text
%        str2double(get(hObject,'String')) returns contents of ReloadVelocityValue as a double


% --- Executes during object creation, after setting all properties.
function ReloadVelocityValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReloadVelocityValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LoadVelocityValue_Callback(hObject, eventdata, handles)
% hObject    handle to LoadVelocityValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LoadVelocityValue as text
%        str2double(get(hObject,'String')) returns contents of LoadVelocityValue as a double


% --- Executes during object creation, after setting all properties.
function LoadVelocityValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoadVelocityValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HoldFrictionValue_Callback(hObject, eventdata, handles)
% hObject    handle to HoldFrictionValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HoldFrictionValue as text
%        str2double(get(hObject,'String')) returns contents of HoldFrictionValue as a double


% --- Executes during object creation, after setting all properties.
function HoldFrictionValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HoldFrictionValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HoldTime_Callback(hObject, eventdata, handles)
% hObject    handle to HoldTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HoldTime as text
%        str2double(get(hObject,'String')) returns contents of HoldTime as a double


% --- Executes during object creation, after setting all properties.
function HoldTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HoldTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ListBox.
function ListBox_Callback(hObject, eventdata, handles)
% hObject    handle to ListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ListBox


% --- Executes during object creation, after setting all properties.
function ListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UpdateListboxButton.
function UpdateListboxButton_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateListboxButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update_listbox(handles)

function update_listbox(handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

%%% Updates the listbox to match the current workspace
vars = evalin('base','who');
set(handles.ListBox,'String',vars)



function SlipFit_muValue_Callback(hObject, eventdata, handles)
% hObject    handle to SlipFit_muValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipFit_muValue as text
%        str2double(get(hObject,'String')) returns contents of SlipFit_muValue as a double


% --- Executes during object creation, after setting all properties.
function SlipFit_muValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipFit_muValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SlipFit_aValue_Callback(hObject, eventdata, handles)
% hObject    handle to SlipFit_aValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipFit_aValue as text
%        str2double(get(hObject,'String')) returns contents of SlipFit_aValue as a double


% --- Executes during object creation, after setting all properties.
function SlipFit_aValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipFit_aValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SlipFit_bValue_Callback(hObject, eventdata, handles)
% hObject    handle to SlipFit_bValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipFit_bValue as text
%        str2double(get(hObject,'String')) returns contents of SlipFit_bValue as a double


% --- Executes during object creation, after setting all properties.
function SlipFit_bValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipFit_bValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SlipFit_dcValue_Callback(hObject, eventdata, handles)
% hObject    handle to SlipFit_dcValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipFit_dcValue as text
%        str2double(get(hObject,'String')) returns contents of SlipFit_dcValue as a double


% --- Executes during object creation, after setting all properties.
function SlipFit_dcValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipFit_dcValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SlipFit_kValue_Callback(hObject, eventdata, handles)
% hObject    handle to SlipFit_kValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipFit_kValue as text
%        str2double(get(hObject,'String')) returns contents of SlipFit_kValue as a double


% --- Executes during object creation, after setting all properties.
function SlipFit_kValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipFit_kValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Guess_b2Value_Callback(hObject, eventdata, handles)
% hObject    handle to Guess_b2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Guess_b2Value as text
%        str2double(get(hObject,'String')) returns contents of Guess_b2Value as a double


% --- Executes during object creation, after setting all properties.
function Guess_b2Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Guess_b2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgingFit_b2Value_Callback(hObject, eventdata, handles)
% hObject    handle to AgingFit_b2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgingFit_b2Value as text
%        str2double(get(hObject,'String')) returns contents of AgingFit_b2Value as a double


% --- Executes during object creation, after setting all properties.
function AgingFit_b2Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgingFit_b2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SlipFit_b2Value_Callback(hObject, eventdata, handles)
% hObject    handle to SlipFit_b2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipFit_b2Value as text
%        str2double(get(hObject,'String')) returns contents of SlipFit_b2Value as a double


% --- Executes during object creation, after setting all properties.
function SlipFit_b2Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipFit_b2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Guess_dc2Value_Callback(hObject, eventdata, handles)
% hObject    handle to Guess_dc2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Guess_dc2Value as text
%        str2double(get(hObject,'String')) returns contents of Guess_dc2Value as a double


% --- Executes during object creation, after setting all properties.
function Guess_dc2Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Guess_dc2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgingFit_dc2Value_Callback(hObject, eventdata, handles)
% hObject    handle to AgingFit_dc2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgingFit_dc2Value as text
%        str2double(get(hObject,'String')) returns contents of AgingFit_dc2Value as a double


% --- Executes during object creation, after setting all properties.
function AgingFit_dc2Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgingFit_dc2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SlipFit_dc2Value_Callback(hObject, eventdata, handles)
% hObject    handle to SlipFit_dc2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipFit_dc2Value as text
%        str2double(get(hObject,'String')) returns contents of SlipFit_dc2Value as a double


% --- Executes during object creation, after setting all properties.
function SlipFit_dc2Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipFit_dc2Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveWorkspaceButton.
function SaveWorkspaceButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveWorkspaceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Get the filename and save the entire workspace.
    WorkspaceName = get(handles.WorkspaceName,'String');
    evalin('base', sprintf('save(''%s'')', WorkspaceName));


function WorkspaceName_Callback(hObject, eventdata, handles)
% hObject    handle to WorkspaceName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WorkspaceName as text
%        str2double(get(hObject,'String')) returns contents of WorkspaceName as a double


% --- Executes during object creation, after setting all properties.
function WorkspaceName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WorkspaceName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SHSButton.
function SHSButton_Callback(hObject, eventdata, handles)
% hObject    handle to SHSButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SHSButton

set(findall(handles.VelocityStepPanel, '-property', 'Enable'), 'Enable', 'off')
set(findall(handles.SHSPanel, '-property', 'Enable'), 'Enable', 'on')

% --- Executes when selected object is changed in EventButtonGroup.
%function EventButtonGroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in EventButtonGroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%str = get(hObject, 'Tag');
%if strcmp(str, 'SHSButton')
%    setappdata(handles.FitButton,'EventFlag',false);
%else
%    setappdata(handles.FitButton,'EventFlag',true);
%end


% --- Executes on button press in VelocityStepButton.
function VelocityStepButton_Callback(hObject, eventdata, handles)
% hObject    handle to VelocityStepButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VelocityStepButton

set(findall(handles.VelocityStepPanel, '-property', 'Enable'), 'Enable', 'on')
set(findall(handles.SHSPanel, '-property', 'Enable'), 'Enable', 'off')


% --- Executes on mouse press over axes background.
function MainAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to MainAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% See if there's a previous box plotted and delete it.
    children = get(handles.StaticAxes, 'children');
    if numel(children) > 1
        delete(children(1:end-1));
    end
%%% Plot outline box on static axes when limits of main axes are changed.    
    XLimZoom = get(handles.MainAxes,'XLim');
    YLimZoom = get(handles.MainAxes,'YLim');
    hold(handles.StaticAxes, 'on');
    plot(handles.StaticAxes,XLimZoom,YLimZoom(1)*[1 1],'r','LineWidth',2)
    plot(handles.StaticAxes,XLimZoom,YLimZoom(2)*[1 1],'r','LineWidth',2)
    plot(handles.StaticAxes,XLimZoom(1)*[1 1],YLimZoom,'r','LineWidth',2)
    plot(handles.StaticAxes,XLimZoom(2)*[1 1],YLimZoom,'r','LineWidth',2)


% --- Executes on button press in TestButton.
function TestButton_Callback(hObject, eventdata, handles)
% hObject    handle to TestButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% See if there's any previous lines plotted and delete them.
children = get(handles.FittingAxes, 'children');
if numel(children) > 1
    delete(children(1:end-1));
end

%%% Get the stuff.
[x_0,x_e,x_L,NormStress,Slip_ZeroRef,Time_ZeroRef,StateVarFlag,...
    StiffnessFlag,MuFlag,Weight] = GetStuff(handles);

a = x_0(2);
b1 = x_0(3);
d_c1 = x_0(4);
b2 = x_0(6);
d_c2 = x_0(7);
if MuFlag == true
    mu_0 = x_0(1);
else
    mu_0 = x_e(1);
end
%%% Run a spring-slider simulation using the guessed parameters.
Period = 2*pi/x_L(3);
Time_Eval = 6*Period + Time_ZeroRef;
tspan = [0 Time_Eval(end)];
v_i = x_L(1);
state1_i = d_c1/v_i;
if StateVarFlag
    state2_i = d_c2/v_i;
    mu_i = mu_0 + a*log(v_i/v_i) + b1*log(v_i*state1_i/d_c1)...
        + b2*log(v_i*state2_i/d_c2);
else
    state2_i = 0;
    mu_i = mu_0 + a*log(v_i/v_i) + b1*log(v_i*state1_i/d_c1);
end
sigma_i = NormStress;
tau_i = mu_i*sigma_i;
slip_i = Slip_ZeroRef(1);
Vars_i = [state1_i; state2_i; v_i; mu_i; slip_i; sigma_i; tau_i];
opt = odeset('RelTol',1e-9,'AbsTol',[1e-12 1e-12 1e-32 1e-12 1e-12 1e-12 1e-12]);

%%% Check what fits to do.
AgingLawFlag = getappdata(handles.FitButton, 'AgingLawFlag');
SlipLawFlag = getappdata(handles.FitButton, 'SlipLawFlag');

if AgingLawFlag == 1
%%% Aging law test.
StateLawFlag = true;
%if EventFlag
%    ODE_Sol = ode45(@(time,Vars)SpringBlock(time,Vars,x_0,x_e,v_i,v_f,TimeOfStep,...
%        StateLawFlag,StateVarFlag,EventFlag,StiffnessFlag,MuFlag),...
%        Time_ZeroRef,Vars_i,opt);
%%% Compute the load point slip.
%    Slip_f = nan(numel(Time_ZeroRef), 1);
%    [~, kk1] = min(abs(Time_ZeroRef - TimeOfStep));
%    Slip_f(1:kk1) = v_i*Time_ZeroRef(1:kk1);
%    Slip_f(kk1+1:end) = Slip_f(kk1) + v_f*cumsum(diff(Time_ZeroRef(kk1:end)));
%else
%    HoldTime = Holds{1};
%    TimeOfHold = Holds{2};
    ODE_Sol = ode15s(@(time,Vars)SpringBlock(time,Vars,x_0,x_e,x_L,StateLawFlag,...
        StateVarFlag,StiffnessFlag,MuFlag), tspan,Vars_i,opt);
%%% Compute the load point slip.
%    Slip_f = nan(numel(Time_ZeroRef), 1);
%    [~, kk1] = min(abs(Time_ZeroRef - TimeOfHold));
%    [~, kk2] = min(abs(Time_ZeroRef - (TimeOfHold + HoldTime)));
%    Slip_f(1:kk1) = v_i*Time_ZeroRef(1:kk1);
%    Slip_f(kk1+1:kk2) = Slip_f(kk1);
%    Slip_f(kk2+1:end) = Slip_f(kk2) + v_f*cumsum(diff(Time_ZeroRef(kk2:end)));
%end    
%    N_T = Time_ZeroRef(end)/Period;
    bestY = deval(ODE_Sol, Time_Eval);
%    Time_Eval = Time_Eval - Time_Eval(1);
%bestY = deval(ODE_Sol, Time_ZeroRef);
    Mu_f = bestY(4,:)';

%%% Plot the test over the detrended data in the fitting axes. 
    hold(handles.FittingAxes, 'on');

        PAgingTest = plot(handles.FittingAxes,Time_ZeroRef, Mu_f, 'r',...
            'LineWidth', 2, 'LineStyle', '--');
%    end
    hold(handles.FittingAxes, 'off');
end


if SlipLawFlag == 1
%%% Slip law test.
StateLawFlag = false;
%if EventFlag
%    ODE_Sol = ode45(@(time,Vars)SpringBlock(time,Vars,x_0,x_e,v_i,v_f,TimeOfStep,...
%        StateLawFlag,StateVarFlag,EventFlag,StiffnessFlag,MuFlag),...
%        Time_ZeroRef,Vars_i,opt);
%%% Compute the load point slip.
%    Slip_f = nan(numel(Time_ZeroRef), 1);
%    [~, kk1] = min(abs(Time_ZeroRef - TimeOfStep));
%    Slip_f(1:kk1) = v_i*Time_ZeroRef(1:kk1);
%    Slip_f(kk1+1:end) = Slip_f(kk1) + v_f*cumsum(diff(Time_ZeroRef(kk1:end)));    
%else
%    HoldTime = Holds{1};
%    TimeOfHold = Holds{2};
    ODE_Sol = ode15s(@(time,Vars)SpringBlock(time,Vars,x_0,x_e,x_L,StateLawFlag,...
        StateVarFlag,StiffnessFlag,MuFlag), tspan,Vars_i,opt);
%%% Compute the load point slip
%    Slip_f = nan(numel(Time_ZeroRef), 1);
%    [~, kk1] = min(abs(Time_ZeroRef - TimeOfHold));
%    [~, kk2] = min(abs(Time_ZeroRef - (TimeOfHold + HoldTime)));
%    Slip_f(1:kk1) = v_i*Time_ZeroRef(1:kk1);
%    Slip_f(kk1+1:kk2) = Slip_f(kk1);
%    Slip_f(kk2+1:end) = Slip_f(kk2) + v_f*cumsum(diff(Time_ZeroRef(kk2:end)));
%end    
bestY = deval(ODE_Sol, Time_Eval);
Mu_f = bestY(4,:)';

%%% Plot the test over the detrended data in the fitting axes. 
    hold(handles.FittingAxes, 'on');
%    if EventFlag
%        PSlipTest = plot(handles.FittingAxes,Slip_f, Mu_f, 'c',...
%            'LineWidth', 2, 'LineStyle', '--');
%    else
        PSlipTest = plot(handles.FittingAxes,Time_ZeroRef, Mu_f, 'c',...
            'LineWidth', 2, 'LineStyle', '--');
%    end
    hold(handles.FittingAxes, 'off');
end

%%% Create the legend and place it based on the event type
LegLoc = 'best';
if AgingLawFlag == 1 && SlipLawFlag == 1
    legend(handles.FittingAxes, [PAgingTest, PSlipTest],...
        'Aging Law Test', 'Slip Law Test', 'Location', LegLoc);
    setappdata(handles.TestButton, 'Plot_ATest', PAgingTest);
    setappdata(handles.TestButton, 'Plot_STest', PSlipTest);
elseif AgingLawFlag == 1 && SlipLawFlag == 0
    legend(handles.FittingAxes, PAgingTest, 'Aging Law Test', 'Location',...
        LegLoc);
    setappdata(handles.TestButton, 'Plot_ATest', PAgingTest);
elseif AgingLawFlag == 0 && SlipLawFlag == 1
    legend(handles.FittingAxes, PSlipTest, 'Slip Law Test', 'Location',...
        LegLoc);
    setappdata(handles.TestButton, 'Plot_STest', PSlipTest);
end

function Guess_alphaValue_Callback(hObject, eventdata, handles)
% hObject    handle to Guess_alphaValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Guess_alphaValue as text
%        str2double(get(hObject,'String')) returns contents of Guess_alphaValue as a double


% --- Executes during object creation, after setting all properties.
function Guess_alphaValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Guess_alphaValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgingFit_alphaValue_Callback(hObject, eventdata, handles)
% hObject    handle to AgingFit_alphaValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgingFit_alphaValue as text
%        str2double(get(hObject,'String')) returns contents of AgingFit_alphaValue as a double


% --- Executes during object creation, after setting all properties.
function AgingFit_alphaValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgingFit_alphaValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SlipFit_alphaValue_Callback(hObject, eventdata, handles)
% hObject    handle to SlipFit_alphaValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipFit_alphaValue as text
%        str2double(get(hObject,'String')) returns contents of SlipFit_alphaValue as a double


% --- Executes during object creation, after setting all properties.
function SlipFit_alphaValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipFit_alphaValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function LDPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LDPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function StaticMuMin_Callback(hObject, eventdata, handles)
% hObject    handle to StaticMuMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StaticMuMin as text
%        str2double(get(hObject,'String')) returns contents of StaticMuMin as a double


% --- Executes during object creation, after setting all properties.
function StaticMuMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StaticMuMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StaticMuMax_Callback(hObject, eventdata, handles)
% hObject    handle to StaticMuMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StaticMuMax as text
%        str2double(get(hObject,'String')) returns contents of StaticMuMax as a double


% --- Executes during object creation, after setting all properties.
function StaticMuMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StaticMuMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uitoggletool1_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom_handle = zoom(handles.MainAxes);
zoom_handle.ActionPostCallback = @MainAxPostCallback;

function MainAxPostCallback(obj,event_obj)
%%% Get x- and y-limits of new zoomed area and plot a red box on the static
%%% axes.
if isempty(event_obj.Axes.ButtonDownFcn) == 0
    XLimZoom = event_obj.Axes.XLim;
    YLimZoom = event_obj.Axes.YLim;
    handles = guidata(obj);
%%% See if there's a previous box plotted and delete it.
    children = get(handles.StaticAxes, 'children');
    if numel(children) > 1
        delete(children(1:end-1));
    end
%%% Plot outline box on static axes when limits of main axes are changed.    
    hold(handles.StaticAxes, 'on');
    plot(handles.StaticAxes,XLimZoom,YLimZoom(1)*[1 1],'r','LineWidth',2);
    plot(handles.StaticAxes,XLimZoom,YLimZoom(2)*[1 1],'r','LineWidth',2);
    plot(handles.StaticAxes,XLimZoom(1)*[1 1],YLimZoom,'r','LineWidth',2);
    plot(handles.StaticAxes,XLimZoom(2)*[1 1],YLimZoom,'r','LineWidth',2);
    hold(handles.StaticAxes, 'off');
end

% --------------------------------------------------------------------
function uitoggletool3_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pan_handle = pan(handles.RASGUI);
pan_handle.ActionPostCallback = @MainAxPostCallback;



function P_cDataName_Callback(hObject, eventdata, handles)
% hObject    handle to P_cDataName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P_cDataName as text
%        str2double(get(hObject,'String')) returns contents of P_cDataName as a double


% --- Executes during object creation, after setting all properties.
function P_cDataName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P_cDataName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StiffnessButton.
function StiffnessButton_Callback(hObject, eventdata, handles)
% hObject    handle to StiffnessButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Get the status of the evolution law buttons button.
AgingLawFlag = getappdata(handles.FitButton, 'AgingLawFlag');
SlipLawFlag = getappdata(handles.FitButton, 'SlipLawFlag');

if (get(hObject,'Value') == get(hObject,'Max'))
%%% Button is selected, enable the alpha variable field, and set the
%%% StiffnessFlag to "false".
    setappdata(handles.FitButton, 'StiffnessFlag', false);
    set(handles.AgingFit_kValue, 'Enable', 'off')
    set(handles.SlipFit_kValue, 'Enable', 'off')
else
%%% Button is not selected, disable the alpha variable field, and set the 
%%% StiffnessFlag to "true".
    setappdata(handles.FitButton, 'StiffnessFlag', true);
    if AgingLawFlag
        set(handles.AgingFit_kValue, 'Enable', 'on')
    end
    if SlipLawFlag
        set(handles.SlipFit_kValue, 'Enable', 'on')
    end
end

% --- Executes on button press in MuButton.
function MuButton_Callback(hObject, eventdata, handles)
% hObject    handle to MuButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Get the status of the evolution law buttons button.
AgingLawFlag = getappdata(handles.FitButton, 'AgingLawFlag');
SlipLawFlag = getappdata(handles.FitButton, 'SlipLawFlag');

if (get(hObject,'Value') == get(hObject,'Max'))
%%% Button is selected, enable the alpha variable field, and set the MuFlag
%%% to "true".
    setappdata(handles.FitButton, 'MuFlag', false);
    set(handles.AgingFit_muValue, 'Enable', 'off')
    set(handles.SlipFit_muValue, 'Enable', 'off')
else
%%% Button is not selected, disable the alpha variable field, and set the 
%%% MuFlag to "false".
    setappdata(handles.FitButton, 'MuFlag', true);
    if AgingLawFlag
        set(handles.AgingFit_muValue, 'Enable', 'on')
    end
    if SlipLawFlag
        set(handles.SlipFit_muValue, 'Enable', 'on')
    end
end

% --- Executes on button press in WeightButton.
function WeightButton_Callback(hObject, eventdata, handles)
% hObject    handle to WeightButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WeightButton

if (get(hObject,'Value') == get(hObject,'Max'))
%%% Button is selected, enable the alpha variable field, and set the
%%% WeightFlag to "true".
    setappdata(handles.FitButton, 'WeightFlag', true);
    set(findall(handles.WeightPanel, '-property', 'Enable'), 'Enable', 'on')
else
%%% Button is not selected, disable the alpha variable field, and set the 
%%% WeightFlag to "false".   
    setappdata(handles.FitButton, 'WeightFlag', false);
    set(findall(handles.WeightPanel, '-property', 'Enable'),...
        'Enable', 'off')
end



function WeightSlipValue_Callback(hObject, eventdata, handles)
% hObject    handle to WeightSlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WeightSlipValue as text
%        str2double(get(hObject,'String')) returns contents of WeightSlipValue as a double


% --- Executes during object creation, after setting all properties.
function WeightSlipValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WeightSlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in WeightLocButton.
function WeightLocButton_Callback(hObject, eventdata, handles)
% hObject    handle to WeightLocButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    Time_ZeroRef = getappdata(handles.DetrendButton,'TimeZeroRef_Data');
    Slip_ZeroRef = getappdata(handles.DetrendButton,'SlipZeroRef_Data');
%%% Set the data point to be recorded when the left mouse button is
%%% clicked.
    datacursormode on
    waitforbuttonpress
    cursorMode = datacursormode(gcf);
    dcm_Info = getCursorInfo(cursorMode);
    Position = dcm_Info.Position;
    datacursormode off
%    EventFlag = getappdata(handles.FitButton, 'EventFlag');
%    if EventFlag
%        WeightSlip = Position(1);
%    else
        [~, ii] = min(abs(Time_ZeroRef - Position(1)));
        WeightSlip = Slip_ZeroRef(ii);
%    end
    set(handles.WeightSlipValue, 'String', num2str(WeightSlip));
    set(handles.WeightFrictionValue, 'String', num2str(Position(2)));
%%% Store slip value for detrending later.
    setappdata(handles.WeightSlipValue,'Weight_SlipValue',WeightSlip);
    setappdata(handles.WeightFrictionValue,'Weight_SlipValue',Position(2));
%%% Calculate the weights and plot in a new window.    
    [Weight, WeightInfo] = WeightCalc(handles);
    figure;
%    if EventFlag
%        semilogy(Slip_ZeroRef, Weight, 'k', 'LineWidth', 2);
%        xlabel('Load Point Displacement (\mum)');
%    else
        semilogy(Time_ZeroRef, Weight, 'k', 'LineWidth', 2);
        xlabel('Time (s)');
%    end
    ylabel('Weight (N / i_w)^p');
    title(['N = ', num2str(WeightInfo(1)), ' total data points, i_w = ',...
        num2str(WeightInfo(2)), ', p = ', num2str(WeightInfo(3))]);

function [Weight, WeightInfo] = WeightCalc(handles)
    Slip_ZeroRef = getappdata(handles.DetrendButton,'SlipZeroRef_Data');
    N = numel(Slip_ZeroRef);
    Weight = ones(1, N);
    slip_weight = get(handles.WeightSlipValue, 'String');
    SlipWeight = str2double(slip_weight);
    [~, i_w] = min(abs(Slip_ZeroRef - SlipWeight));
%%% Calculate weight function.
    p_String = get(handles.WeightExponent,'String');
    p = str2double(p_String);
    Weight(1, i_w:end) = (N./(1:N-i_w+1)).^p;
%%% Information for weight function.
    WeightInfo = [N; i_w; p];
%%% Store
    setappdata(handles.WeightLocButton, 'Weight_Function', Weight);
    setappdata(handles.WeightLocButton, 'Weight_Info', [N; i_w; p]);
    

function WeightFrictionValue_Callback(hObject, eventdata, handles)
% hObject    handle to WeightFrictionValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WeightFrictionValue as text
%        str2double(get(hObject,'String')) returns contents of WeightFrictionValue as a double


% --- Executes during object creation, after setting all properties.
function WeightFrictionValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WeightFrictionValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ReferencePointSlipValue_Callback(hObject, eventdata, handles)
% hObject    handle to ReferencePointSlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ReferencePointSlipValue as text
%        str2double(get(hObject,'String')) returns contents of ReferencePointSlipValue as a double


% --- Executes during object creation, after setting all properties.
function ReferencePointSlipValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReferencePointSlipValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ReferencePointMuValue_Callback(hObject, eventdata, handles)
% hObject    handle to ReferencePointMuValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ReferencePointMuValue as text
%        str2double(get(hObject,'String')) returns contents of ReferencePointMuValue as a double


% --- Executes during object creation, after setting all properties.
function ReferencePointMuValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReferencePointMuValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetReferencePointButton.
function SetReferencePointButton_Callback(hObject, eventdata, handles)
% hObject    handle to SetReferencePointButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Set the data point to be recorded when the left mouse button is
%%% clicked.
    datacursormode on
    waitforbuttonpress
    cursorMode = datacursormode(gcf);
    dcm_Info = getCursorInfo(cursorMode);
    Position = dcm_Info.Position;
    datacursormode off
    set(handles.ReferencePointSlipValue, 'String', num2str(Position(1)));
    set(handles.ReferencePointMuValue, 'String', num2str(Position(2)));
%%% Store slip value for detrending later.
    setappdata(handles.ReferencePointSlipValue,'ReferencePoint_SlipValue',Position(1));

% --- Executes on button press in ClearTestLines.
function ClearTestLines_Callback(hObject, eventdata, handles)
% hObject    handle to ClearTestLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% See if there's any test lines plotted and delete them.
children = get(handles.FittingAxes, 'children');
%EventFlag = getappdata(handles.FitButton, 'EventFlag');
if numel(children) > 1
    for i = 1:numel(children)
%%% Check if fit lines are present.
        if strcmp('Aging Law Fit', get(children(i), 'DisplayName'))
            PAgingFit = getappdata(handles.TestButton, 'Plot_AFit');        
        elseif strcmp('Slip Law Fit', get(children(i), 'DisplayName'))
            PSlipFit = getappdata(handles.TestButton, 'Plot_SFit');
        end
        if strcmp('--', get(children(i), 'LineStyle'))
            delete(children(i));
        end
    end
%%% Reset the legend
    LegLoc = 'best';
    if exist('PAgingFit', 'var') && exist('PSlipFit', 'var')
        legend(handles.FittingAxes, [PAgingFit, PSlipFit], 'Aging Law Fit',...
            'Slip Law Fit', 'Location', LegLoc);
    elseif exist('PAgingFit', 'var') && exist('PSlipFit', 'var') == 0
        legend(handles.FittingAxes, PAgingFit, 'Aging Law Fit',...
             'Location', LegLoc);
    elseif exist('PAgingFit', 'var') == 0 && exist('PSlipFit', 'var')
        legend(handles.FittingAxes, PSlipFit, 'Slip Law Fit',...
             'Location', LegLoc);
    else
        legend('off');
    end    
end

% --- Executes on button press in ClearFitLines.
function ClearFitLines_Callback(hObject, eventdata, handles)
% hObject    handle to ClearFitLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% See if there's any fit lines plotted and delete them.
children = get(handles.FittingAxes, 'children');
%EventFlag = getappdata(handles.FitButton, 'EventFlag');
if numel(children) > 1
    for i = 1:numel(children)
%%% Check if test lines are present.
        if strcmp('Aging Law Test', get(children(i), 'DisplayName'))
            PAgingTest = getappdata(handles.TestButton, 'Plot_ATest');        
        elseif strcmp('Slip Law Test', get(children(i), 'DisplayName'))
            PSlipTest = getappdata(handles.TestButton, 'Plot_STest');
        end
        if strcmp('-', get(children(i), 'LineStyle'))
            delete(children(i));
        end
    end
%%% Reset the legend
    LegLoc = 'best';
    if exist('PAgingTest', 'var') && exist('PSlipTest', 'var')
        legend(handles.FittingAxes, [PAgingTest, PSlipTest], 'Aging Law Test',...
            'Slip Law Test', 'Location', LegLoc);
    elseif exist('PAgingTest', 'var') && exist('PSlipTest', 'var') == 0
        legend(handles.FittingAxes, PAgingTest, 'Aging Law Test',...
            'Location', LegLoc);
    elseif exist('PAgingTest', 'var') == 0 && exist('PSlipTest', 'var')
        legend(handles.FittingAxes, PSlipTest, 'Slip Law Test',...
            'Location', LegLoc);
    else
        legend('off');
    end
end



function WeightExponent_Callback(hObject, eventdata, handles)
% hObject    handle to WeightExponent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WeightExponent as text
%        str2double(get(hObject,'String')) returns contents of WeightExponent as a double


% --- Executes during object creation, after setting all properties.
function WeightExponent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WeightExponent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SampleSlipDataName_Callback(hObject, eventdata, handles)
% hObject    handle to SampleSlipDataName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SampleSlipDataName as text
%        str2double(get(hObject,'String')) returns contents of SampleSlipDataName as a double


% --- Executes during object creation, after setting all properties.
function SampleSlipDataName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SampleSlipDataName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SampleSlipButton.
function SampleSlipButton_Callback(hObject, eventdata, handles)
% hObject    handle to SampleSlipButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(hObject,'Value') == get(hObject,'Max'))
%%% Button is selected, enable the sample slip data field, and set the
%%% SampleSlipFlag to "true".
    setappdata(handles.FitButton, 'SampleSlipFlag', true);
    set(handles.SampleSlipDataName, 'Enable', 'on');
else
%%% Button is not selected, disable the sample slip data field, and set the
%%% SampleSlipFlag to "false".
    setappdata(handles.FitButton, 'SampleSlipFlag', false);
    set(handles.SampleSlipDataName, 'Enable', 'off');
end



function LocNormStress_Callback(hObject, eventdata, handles)
% hObject    handle to LocNormStress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LocNormStress as text
%        str2double(get(hObject,'String')) returns contents of LocNormStress as a double


% --- Executes during object creation, after setting all properties.
function LocNormStress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LocNormStress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AgingButton.
function AgingButton_Callback(hObject, eventdata, handles)
% hObject    handle to AgingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Get the status of the two state variable button, and the constrain mu_0
%%% and stiffness buttons.
StateVarFlag = getappdata(handles.FitButton, 'StateVarFlag');
MuFlag = getappdata(handles.FitButton, 'MuFlag');
StiffnessFlag = getappdata(handles.FitButton, 'StiffnessFlag');

if (get(hObject,'Value') == get(hObject,'Max'))
%%% Button is selected, enable the aging law data fields, and set the
%%% AgingLawFlag to "true".
    setappdata(handles.FitButton, 'AgingLawFlag', true);
    set(handles.AgingFit_aValue, 'Enable', 'on');
    set(handles.AgingFit_bValue, 'Enable', 'on');    
    set(handles.AgingFit_dcValue, 'Enable', 'on');    
    set(handles.AgingRes, 'Enable', 'on');
    set(handles.AgingFlag, 'Enable', 'on');
    if StateVarFlag
        set(handles.AgingFit_b2Value, 'Enable', 'on');
        set(handles.AgingFit_dc2Value, 'Enable', 'on');
    end
    if StiffnessFlag
        set(handles.AgingFit_kValue, 'Enable', 'on');
    end
    if MuFlag
        set(handles.AgingFit_muValue, 'Enable', 'on');
    end
else
%%% Button is not selected, disable the aging law data fields, and set the
%%% AgingLawFlag to "false".
    setappdata(handles.FitButton, 'AgingLawFlag', false);
    set(handles.AgingFit_muValue, 'Enable', 'off');
    set(handles.AgingFit_aValue, 'Enable', 'off');
    set(handles.AgingFit_bValue, 'Enable', 'off');
    set(handles.AgingFit_b2Value, 'Enable', 'off');
    set(handles.AgingFit_dcValue, 'Enable', 'off');
    set(handles.AgingFit_dc2Value, 'Enable', 'off');
    set(handles.AgingFit_kValue, 'Enable', 'off');
    set(handles.AgingRes, 'Enable', 'off');
    set(handles.AgingFlag, 'Enable', 'off');
end


% --- Executes on button press in SlipButton.
function SlipButton_Callback(hObject, eventdata, handles)
% hObject    handle to SlipButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% Get the status of the two state variable button, and the constrain mu_0
%%% and stiffness buttons.
StateVarFlag = getappdata(handles.FitButton, 'StateVarFlag');
MuFlag = getappdata(handles.FitButton, 'MuFlag');
StiffnessFlag = getappdata(handles.FitButton, 'StiffnessFlag');

if (get(hObject,'Value') == get(hObject,'Max'))
%%% Button is selected, enable the slip law data fields, and set the
%%% SlipLawFlag to "true".
    setappdata(handles.FitButton, 'SlipLawFlag', true);
    set(handles.SlipFit_aValue, 'Enable', 'on');
    set(handles.SlipFit_bValue, 'Enable', 'on');    
    set(handles.SlipFit_dcValue, 'Enable', 'on');    
    set(handles.SlipRes, 'Enable', 'on');
    set(handles.SlipFlag, 'Enable', 'on');
    if StateVarFlag
        set(handles.SlipFit_b2Value, 'Enable', 'on');
        set(handles.SlipFit_dc2Value, 'Enable', 'on');
    end
    if StiffnessFlag
        set(handles.SlipFit_kValue, 'Enable', 'on');
    end
    if MuFlag
        set(handles.SlipFit_muValue, 'Enable', 'on');
    end
else
%%% Button is not selected, disable the slip law data fields, and set the
%%% SlipLawFlag to "false".
    setappdata(handles.FitButton, 'SlipLawFlag', false);
    set(handles.SlipFit_muValue, 'Enable', 'off');
    set(handles.SlipFit_aValue, 'Enable', 'off');
    set(handles.SlipFit_bValue, 'Enable', 'off');
    set(handles.SlipFit_b2Value, 'Enable', 'off');
    set(handles.SlipFit_dcValue, 'Enable', 'off');
    set(handles.SlipFit_dc2Value, 'Enable', 'off');
    set(handles.SlipFit_kValue, 'Enable', 'off');
    set(handles.SlipRes, 'Enable', 'off');
    set(handles.SlipFlag, 'Enable', 'off');
end



function AgingRes_Callback(hObject, eventdata, handles)
% hObject    handle to AgingRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgingRes as text
%        str2double(get(hObject,'String')) returns contents of AgingRes as a double


% --- Executes during object creation, after setting all properties.
function AgingRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgingRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgingFlag_Callback(hObject, eventdata, handles)
% hObject    handle to AgingFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgingFlag as text
%        str2double(get(hObject,'String')) returns contents of AgingFlag as a double


% --- Executes during object creation, after setting all properties.
function AgingFlag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgingFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SlipRes_Callback(hObject, eventdata, handles)
% hObject    handle to SlipRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipRes as text
%        str2double(get(hObject,'String')) returns contents of SlipRes as a double


% --- Executes during object creation, after setting all properties.
function SlipRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SlipFlag_Callback(hObject, eventdata, handles)
% hObject    handle to SlipFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlipFlag as text
%        str2double(get(hObject,'String')) returns contents of SlipFlag as a double


% --- Executes during object creation, after setting all properties.
function SlipFlag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlipFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearPointsButton.
function ClearPointsButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearPointsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% See if there is a previous detrend line plotted and delete it.
    children = get(handles.MainAxes, 'children');
    if numel(children) > 1
        delete(children(1:end-1));
    end 
%%% Clear all the displayed and stored values from any previous detrend.    
    set(handles.Point1SlipValue, 'String', [ ]);
    set(handles.Point1MuValue, 'String', [ ]);
    set(handles.Point2SlipValue, 'String', [ ]);
    set(handles.Point2MuValue, 'String',[ ]);
    set(handles.ReferencePointSlipValue, 'String', [ ]);
    set(handles.ReferencePointMuValue, 'String',[ ]);
    setappdata(handles.ReferencePointSlipValue,'ReferencePoint_SlipValue', [ ]);
    set(handles.SlopeValue, 'String', [ ]);
    setappdata(handles.SlopeValue,'Slope_Value', [ ]);




function VelocityMean_Callback(hObject, eventdata, handles)
% hObject    handle to VelocityMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VelocityMean as text
%        str2double(get(hObject,'String')) returns contents of VelocityMean as a double


% --- Executes during object creation, after setting all properties.
function VelocityMean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VelocityMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VelocityAmp_Callback(hObject, eventdata, handles)
% hObject    handle to VelocityAmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VelocityAmp as text
%        str2double(get(hObject,'String')) returns contents of VelocityAmp as a double


% --- Executes during object creation, after setting all properties.
function VelocityAmp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VelocityAmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SignalPeriod_Callback(hObject, eventdata, handles)
% hObject    handle to SignalPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SignalPeriod as text
%        str2double(get(hObject,'String')) returns contents of SignalPeriod as a double


% --- Executes during object creation, after setting all properties.
function SignalPeriod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SignalPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SignalPhase_Callback(hObject, eventdata, handles)
% hObject    handle to SignalPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SignalPhase as text
%        str2double(get(hObject,'String')) returns contents of SignalPhase as a double


% --- Executes during object creation, after setting all properties.
function SignalPhase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SignalPhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
