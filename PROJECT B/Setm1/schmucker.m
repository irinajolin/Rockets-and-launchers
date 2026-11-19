function [Pr_sch, Me] = schmucker(Pr_sch,Me, Pr_exit)
if isempty(Pr_sch) && ~isempty(Me)
    %Pr_sch=Pe/Pa;
    %tenim mach i calculem Pr
    Pr_sch=(1.88.*Me -1).^(-0.64);
    Me = Me;
elseif  isempty(Me) && ~isempty(Pr_sch)
    %tenim Pr  i volem Me
    Me = (Pr_sch.^(-1/0.64) + 1)./1.88;
end
if ~isempty(Pr_exit)
    if Pr_exit < Pr_sch
        fprintf('Schmucker: SEPARATION RISK\n');
    else
        fprintf('Schmucker: NO SEPARATION RISK\n');
    end
end
end
