function [aa_lbp, tof_lbp, dv, tof_dv] = Simulate_measurements(img_dim, no_measurements, no_sensors, true_img, sens_map, sens_maps_shaped)

[dv, tof_dv] = calc_Rx_loss(img_dim, no_measurements, no_sensors, true_img, sens_map);


N = [64, 64];
mu = 0.02;
lamda = 1;
gamma = 1;
alpha = [1,1];
nBreg = 1;

[aa_lbp,errAll] = Iso_Ani_TV_SB_2D('ani',sens_maps_shaped,dv, N, mu, lamda, gamma, alpha, nBreg);

[tof_lbp,errAll] = Iso_Ani_TV_SB_2D('ani',sens_maps_shaped,tof_dv, N, mu, lamda, gamma, alpha, nBreg);


aa_lbp = abs(aa_lbp);
tof_lbp = abs(tof_lbp);


end

