function [ ] = remove_bad_elec( elec_dat, good_elec, save_it, name )
% In this function we'll remove out the bad electrodes of the particular
% stim (elec_dat) we are working on. there are another options to save the
% data, and showing it also.

data_good = elec_dat(good_elec, :);

if save_it == true
    save(name, 'data_good');
end

end

