function [Pr_sch, Me] = schmucker(Pr_sch,Me)
if isempty(Pr_sch) && ~isempty(Me)
    %Pr_sch=Pe/Pa;
    %tenim mach i calculem Pr
    Pr_sch=(1.88.*Me -1).^(-0.64);
    Me = Me;
elseif  isempty(Me) && ~isempty(Pr_sch)
    %tenim Pr  i volem Me
    Me = (Pr_sch.^(-1/0.64) + 1)./1.88;
end
end
