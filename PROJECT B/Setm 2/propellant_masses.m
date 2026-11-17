function[m_CH4,m_O2]=propellant_masses(m_prop,OF)
% OF = m_O2 / m_CH4
% m_prop = m_CH4 + m_O2;
m_CH4 = m_prop /(1+OF);
m_O2 = m_prop - m_CH4;

end

% queremos calcular cuanto metano y cuanto oxigeno tenemos a partir de los
% datos conocidos 
