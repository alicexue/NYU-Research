function [dirloc] = setup_dir()

% windows: '\'
% mac: '/'

% always write dirloc with '\' 
% the backslash will be changed to the forward slash in the functions using
% strrep(dirloc,'\',filesep)

% uncomment the correct path

% alice
dirloc = 'C:\Users\alice_000\Documents\MATLAB\data';
 
% hypatia
% dirloc = '\Users\purpadmin\Laura\psychophysics\data';

