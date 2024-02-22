classdef BDF < handle
    properties
        order
        coeffs
        dt
    end
    methods
        function obj = BDF(order, dt)
            obj.order = order;
            obj.coeffs = obj.getBdfCoefficients(order);
            obj.dt = dt;
        end

        function dvdt = eval(obj, v, v_prev)
            dvdt = 1/obj.dt*(obj.coeffs(1)*v - sum(obj.coeffs(2:obj.order+1).*v_prev,2));
        end
    end
    methods(Static)
        function coeffs = getBdfCoefficients(order)
            c = zeros(9,10);
            c(1,1) = 1;    c(1,2) = 1;
            c(2,1) = 3;    c(2,2) = 4;     c(2,3) = -1;                     
            c(3,1) = 11;   c(3,2) = 18;    c(3,3) = -9;     c(3,4) = 2;
            c(4,1) = 25;   c(4,2) = 48;    c(4,3) = -36;    c(4,4) = 16;    c(4,5) = -3;
            c(5,1) = 137;  c(5,2) = 300;   c(5,3) = -300;   c(5,4) = 200;   c(5,5) = -75;    c(5,6) = 12; 
            c(6,1) = 147;  c(6,2) = 360;   c(6,3) = -450;   c(6,4) = 400;   c(6,5) = -225;   c(6,6) = 72;    c(6,7) = -10; 
            
            % Note: Higher orders than 6 are not stable for time-stepping
            c(7,1) = 1089; c(7,2) = 2940;  c(7,3) = -4410;  c(7,4) = 4900;  c(7,5) = -3675;  c(7,6) = 1764;  c(7,7) = -490;   c(7,8) = 60; 
            c(8,1) = 2283; c(8,2) = 6720;  c(8,3) = -11760; c(8,4) = 15680; c(8,5) = -14700; c(8,6) = 9408;  c(8,7) = -3920;  c(8,8) = 960;   c(8,9) = -105; 
            c(9,1) = 7129; c(9,2) = 22680; c(9,3) = -45360; c(9,4) = 70560; c(9,5) = -79380; c(9,6) = 63504; c(9,7) = -35280; c(9,8) = 12960; c(9,9) = -2835; c(9,10) = 280; 

            % Scale coefficients
            c(2,:) = c(2,:)/2;
            c(3,:) = c(3,:)/6;
            c(4,:) = c(4,:)/12;
            c(5,:) = c(5,:)/60;
            c(6,:) = c(6,:)/60;
            c(7,:) = c(7,:)/420;
            c(8,:) = c(8,:)/840;
            c(9,:) = c(9,:)/2520;

            coeffs = c(order,:);
        end


    end
end
