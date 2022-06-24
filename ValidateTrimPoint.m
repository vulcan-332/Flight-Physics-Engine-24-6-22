clc

temp =load('trim_values_straight_level');
XStar = temp.XStar;
UStar = temp.UStar;

sim('six_dof_simulation.slx')

t= simX.Time;
X= simX.Data;

figure;
for k=1:9;
    subplot(5,2,k)
    plot(t, X(:,k),'LineWidth',2)
    ylabel(['x_', num2str(k)])
    grid on
end

disp('ALAS IT IS DONE')