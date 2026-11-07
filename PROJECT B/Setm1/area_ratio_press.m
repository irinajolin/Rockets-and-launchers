function epsilon = area_ratio_press(Pc, Pe, gamma)
epsilon = ((sqrt((gamma-1)/2))*(2/(gamma + 1))^((gamma+1)/2*(gamma-1)))/(((Pe/Pc)^(1/gamma))*(sqrt(1-((Pe/Pc)^(gamma-1))/gamma)));
end
