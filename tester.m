%Elaheh Rashedi

function [ output_args ] = tester( input_args )

    clc; clear all; close all;

    
    %=============================================================
    %=======================PARAMETERS============================
    % we are planning to do filtering in few iterations, such that the
    % output of first iteration be input for the next iteration
    iteration_number = 1 ;
    smooth = 1 ; %if u want to smooth the clustering results use 1
    
    R = 350 ; %number of rows of image (depth) 
    C = 300 ; %number of columns of image 
    
    tif0_mat1 = 1 ; %mat file of phantom
    
    if tif0_mat1 == 0
        input_file = sprintf('%d_%d/X_%d_%d.tif',R,C,R,C); 
    else
        input_file = sprintf('phan2S1_4layer.mat');
    end
    
    upload_distance = 1; %if we are going to upload distance matrix from file "distance_filename", set to 1, otherwise 0  
    upload_cluster = 1 ; % upload the hierarchical cluster from the file "cluster_filename"
    upload_cluster_matrix = 1 ; % upload the clustering matrix result from the file "cluster_matrix_filename"
    num_of_clusters = 4 ;
    cutoff = 0 ; % if cutoff is one, then the maximum num_of_clusters is calculated by cut off
    Threashold = 0.2 ; % the threashold for variance of relative difference to recognize speckles 

    distance_filename = sprintf('%d_%d/distance#%d.mat',R,C,iteration_number);
    %Z_attenuation.mat %'Z_Intesity_attenuation.mat' %'Z_Intesity.mat'
    %'cluster10_attenuation.mat' %'cluster10_Intesity.mat'%'cluster10_Intesity_attenuation.mat'
    cluster_filename= sprintf('%d_%d/Z_Intesity_attenuation#%d.mat',R,C,iteration_number); 
    cluster_matrix_filename= sprintf('%d_%d/cluster%d_Intesity_attenuation#%d.mat',R,C,num_of_clusters,iteration_number);
    N = 7 ; % the column size (depth) of window for filtering i
    M = 7 ; % the row size (depth) of window for filtering j
    %features = 1 ; % Intesity    
    features = 2 ; % Intesity attenuation speckle
    % running clustering for first time
    var_window = 0 ; % if we are planning to use variabla windows
    input_file = SkinProcessor( tif0_mat1 , input_file , R , C , upload_distance , upload_cluster , upload_cluster_matrix , num_of_clusters , cutoff , distance_filename , cluster_filename , cluster_matrix_filename , N , M , features , iteration_number , smooth , Threashold , var_window );


% %     smooth = 0 ; %if u want to smooth the clustering results use 1
%     for iteration_number=2:2 
%         
%         upload_distance = 1; %if we are going to upload distance matrix from file "distance_filename", set to 1, otherwise 0  
%         upload_cluster = 0 ; % upload the hierarchical cluster from the file "cluster_filename"
%         upload_cluster_matrix = 0 ; % upload the clustering matrix result from the file "cluster_matrix_filename"
%         
%         distance_filename = sprintf('%d_%d/distance#%d.mat',R,C,iteration_number);
%         %Z_attenuation.mat %'Z_Intesity_attenuation.mat' %'Z_Intesity.mat'
%         %'cluster10_attenuation.mat' %'cluster10_Intesity.mat'%'cluster10_Intesity_attenuation.mat'
%         cluster_filename= sprintf('%d_%d/Z_Intesity_attenuation#%d.mat',R,C,iteration_number); 
%         cluster_matrix_filename= sprintf('%d_%d/cluster%d_Intesity_attenuation#%d.mat',R,C,num_of_clusters,iteration_number);
% 
%         % running clustering for first time
%         input_file = SkinProcessor( tif0_mat1 , input_file , R , C , upload_distance , upload_cluster , upload_cluster_matrix , num_of_clusters , cutoff , distance_filename , cluster_filename , cluster_matrix_filename , N , M , features , iteration_number , smooth , Threashold);
%     end

    
end

