clear all
%%
data_real = importdata('D:\Users\marce\OneDrive - ufpel.edu.br\UFPel\Mestrado\Dissertação\3. SCRIPTS\data_reader\vazoes_C_13150000.xlsx');
chuva     = data_real.data;

data_real       = datetime(data_real.textdata);
ano             = year(data_real(1,1));
data            = datetime(ano,1,1);
%### Mudar, caso a data final seja diferente de 31/12/2018 ###%
data_final      = datetime(2017,12,31); 

data(2,1) = data;

%% CRIANDO VETOR DE DATA COMPLETA PARA O PERÍODO DE INTERESSE
i=1;
for i=1:1000000
    data(i+1,1) = data(i,1)+1;
    if data(i+1,:) == data_final
        break
    else
        i=i+1;
    end
end

%% DIAS JULIANOS PARA A DATA COMPLETA
ano = year(data);
data_inicial = datetime (ano,1,1);
bissexto = leapyear (year(data));

    if bissexto == 1 
        if  data > datetime(ano,2,29)
            Juliano = days365(data_inicial,data)+2;
        else
            Juliano = days365(data_inicial,data)+1;
        end
    else
        Juliano = days365(data_inicial,data)+1;
    end
  
%% PREENCHENDO LACUNAS COM "NaN" DENTRO DA SÉRIE DE DADOS
dados_chuva = timetable(data_real,chuva);
dados_chuva = retime(dados_chuva,'daily','fillwithmissing');
data_real   = timetable2table(dados_chuva);
chuva       = table2array(data_real(:,2));
data_real   = table2array(data_real(:,1));
data_real   = datetime(data_real);


%% DIAS JULIANOS PARA A DATA REAL
ano = year(data_real);
data_inicial = datetime (ano, 1, 1);
bissexto = leapyear(year(data_real));

    if bissexto == 1 
        if data_real > datetime(ano,2,29)
            Juliano_real = days365(data_inicial,data_real)+2;
        else
            Juliano_real = days365(data_inicial,data_real)+1;
        end
    else
        Juliano_real = days365(data_inicial,data_real);
    end
%%
Juliano_real(numel(Juliano))    = 0;
n                               = max(numel(Juliano_real),numel(chuva));
chuva(end+1:n)                  = nan;

%% PREENCHENDO LACUNAS COM "NaN" ANTES E DEPOIS DA SÉRIE
index                                  = abs(Juliano(1,1)-Juliano_real(1,1));
dados_chuva_Juliano(:,1)               = Juliano(:,1);
dados_chuva_Juliano(1:index+1,2)       = NaN();

%% DADOS COMPLETOS COM REFERÊNCIA AO CALERNDÁRIO JULIANO
dados_chuva_Juliano(index+2:end,2)     = chuva(1:end-index-1,1);

%% DADOS DE CHUVA COM REFERÊNCIA AO CALENDÁRIO GREGORIANO
chuva = dados_chuva_Juliano(:,2);
dados_completos_chuva_gregoriano = timetable(data,chuva);

%% EXPORTANDO DADOS 

