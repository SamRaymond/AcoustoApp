
function startApp = main()
%% Test Main file for GUI-Code mix
global nodes parameters particles
close all
clear all
clc
setSimulationParameters();
% Start GUI
acoustofluidicGUI();
startApp = 0;
end