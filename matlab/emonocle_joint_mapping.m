% This file contains the joint mapping for emonocle skeleton
%
%   Vladimir Starostin (vstarostin@emiia.ru)
%   Last update: 08/08/2016
%

% AnkleLeft     14 	Left ankle
% AnkleRight	18 	Right ankle
% ElbowLeft     5 	Left elbow
% ElbowRight	9 	Right elbow
% FootLeft      15 	Left foot
% FootRight     19 	Right foot
% HandLeft      7 	Left hand
% HandRight     11 	Right hand
% HandTipLeft	21 	Tip of the left hand
% HandTipRight	23 	Tip of the right hand
% Head          3 	Head
% HipLeft       12 	Left hip
% HipRight      16 	Right hip
% KneeLeft      13 	Left knee
% KneeRight     17 	Right knee
% Neck          2 	Neck
% ShoulderLeft	4 	Left shoulder
% ShoulderRight	8 	Right shoulder
% SpineBase     0 	Base of the spine
% SpineMid      1 	Middle of the spine
% SpineShoulder	20 	Spine at the shoulder
% ThumbLeft     22 	Left thumb
% ThumbRight	24 	Right thumb
% WristLeft     6 	Left wrist
% WristRight	10 	Right wrist

joint_connections = [...
    % uppder body
    [0 1];          % SpineBase     - SpineMid
    [1 20];         % SpineMid      - SpineShoulder
    [20 2];         % SpineShoulder - Neck
    [2 3];          % Neck          - Head

    % left arm
    [20 4];         % SpineShoulder - ShoulderLeft
    [4 5];          % ShoulderLeft  - ElbowLeft
    [5 6];          % ElbowLeft     - WristLeft
    [6 7];          % WristLeft     - HandLeft
    [7 21];         % HandLeft      - HandTipLeft
    [7 22]          % HandLeft      - ThumbLeft
    
    % right arm
    [20 8];         % SpineShoulder - ShoulderRight
    [8 9];          % ShoulderRight - ElbowRight
    [9 10];         % ElbowRight    - WristRight
    [10 11];        % WristRight    - HandRight
    [11 23];        % HandRight     - HandTipRight
    [11 24];        % HandRight     - ThumbRight
    
    % left leg
    [0 12];         % SpineBase     - HipLeft
    [12 13];        % HipLeft       - KneeLeft
    [13 14];        % KneeLeft      - AnkleLeft
    [14 15];        % AnkleLeft     - FootLeft
    
    % right leg
    [0 16];         % SpineBase     - HipRight
    [16 17];        % HipRight      - KneeRight
    [17 18];        % KneeRight     - AnkleRight
    [18 19];        % AnkleRight    - FootRight
];