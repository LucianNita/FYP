using LinearAlgebra

##generate directions
function direct(n)
	v = rand(n,1)-0.5*ones(n,1);
	v /= norm(v);
end

##define function f
function f(x)
	return -x[1]-x[2];
end

function h(x)
	return x[1]^2+x[2]^2-1;
end

function Checktype(Pk,fx_f,fx_i,hx_i)
	type=0;
	while Pk != 0
		p=pop(Pk);
		if h(p)>0 && h(p)<hx_i && f(p)>fx_i
			type = 1;
		elseif (h(p)>0 && h(p)<hx_i && f(p)<=fx_i || (h(p)=0 && f(p)<fx_i) || (h(p)==hx_i && f(p)<fx_i))
			type = 2;
		end
	end
	return type;
end

function newΔ(type,Δ_k)
	if type == 2 #(𝑖𝑡𝑒𝑟 𝑖𝑠 𝑑𝑜𝑚𝑖𝑛𝑎𝑡𝑖𝑛𝑔)
		∆_kn = 4*∆_k;
	elseif type == 1 # (𝑖𝑡𝑒𝑟 𝑖𝑠 𝑖𝑚𝑝𝑟𝑜𝑣𝑖𝑛𝑔)
		∆_kn = ∆_k;
	else # 𝑖𝑓 𝑡𝑦𝑝𝑒=0 (𝑖𝑡𝑒𝑟 𝑖𝑠 𝑢𝑛𝑠𝑢𝑐𝑐𝑒𝑠𝑓𝑢𝑙𝑙)
		∆_kn=∆_k/4;
	end
	return Δ_kn;
end

function newh_max(type,h_kmax,V_k,hx_i)
	if type == 1
		while V_k != 0
			x=pop!(V_k)
			if h(x) < hx_i
				push!(h(x),h_k);
			end
		end
		h_kmaxn = max(h_k);
	else
	 	h_kmaxn = h_kmax;
	end
	return h_kmaxn;
end

function updateFk(type,fx_f,x_f,V_k)
	if type==2
		Mini=fx_f;
		x=x_f;
		while Vk != 0
			p = pop!(V_k);
			if f(p)<Mini && h(p) == 0
				Mini=f(p)
				x=p;
			end
		end
		return x;
	else
		return fx_f;
	end
end

function updateIk(type,fx_i,hx_i,x_i,V_k)
	if (type == 2 || type == 1)
		Mini=fx_i;
		x=x_i;
		while V_k != 0
			p=pop!(V_k)
			if (f(p) < Mini && h(p) > 0 && h(p) <= hx_i)
				Mini=f(p)
				x=p;
			end
		end
		return x;
	else
		return x_i;
	end
end

tol = 0.0001;
n=2;
x0 = [0,0]
∅ = 0;

if h(x0) ≈ 0
	x_f = x0;
	x_i = ∅;
else
	x_i = x0;
	x_f = ∅;
end

Δ_k=10;
h_kmax=1000;
while (Δ_k < tol || h_kmax > tol)
    d = direct(n);
    #for i in 1:2*n
	if x_i != ∅
    	push!(x_i+Δ_k*d(i),P_k);
	end
	if x_f != ∅
		push!(x_f+Δ_k*d(i),P_k);
	end
    #end
    V_k = P_k;#Caution here
    push!(x_f,V_k);
    push!(x_i,V_k);
    type = Checktype(P_k,f(x_f),f(x_i),h(x_i));
    Δ_k = newΔ(type,Δ_k);
    h_kmax = newh_max(type,h_kmax,V_k,h(x_i));
    x_f = updateF_k(type,f(x_f),x_f,V_k);
    x_i = updateI_k(type,f(x_i),x_i,V_k)
end
