import 'package:drift/src/runtime/query_builder/query_builder.dart';

class Labels {
  static const homeTab = 'Ponto';
  static const analysisTab = 'Análises';
  static const configurationsTab = 'Configurações';
  static const getIn = 'Entrada';
  static const getOut = 'Saída';
  static const pause = 'Pausa';
  static const hours = 'Horas';
  static const workBegins = 'Início de Trabalho';
  static const hourValue = 'Valor/Hora';
  static const profit = 'Ganhos';
  static const cancel = 'Cancelar';
  static const delete = 'Apagar';
  static const save = 'Guardar';
  static const today = 'Hoje';
  static const ok = 'OK';
  static const warning = 'Aviso';
  static const noPointsDayMsg = 'Sem pontos registados.';
  static const deletePointMsg = 'Tem a certeza que pretende apagar este ponto?';
  static const yes = 'Sim';
  static const no = 'Não';

  static const configsListHourValue = 'Definir Valor/Hora';
  static const configsInfo = 'Informação';
  static const configsListNotifications = 'Notificações';
  static const appVersion = 'Versão';
  static const lastUpdate = 'Última atualização';
  static const lastUpdateDate = '22/09/2025';

  // value hour configs
  static const valuesRuleAfterXHour = 'Valor após Hora X';
  static const defineBaseValueHour = 'Valor Base por Hora';
  static const specialRules = 'Regras Especiais';
  static const addNewRule = 'Adicionar Regra';
  static const valueSaved = 'Valor guardado com sucesso';

  static const theme = 'Tema';
}

class HourValueRules {
  static const dayWeekRule = 'Valor/hora no dia da semana';
  static const valueAfterXHoursRule = 'Valor/hora após X horas de trabalho';
  static const valueAfterXScheduleRule = 'Valor/hora após X horário';
  static const newRule = 'Nova Regra';
  static const ruleType = 'Tipo de Regra';
  static const hourValue = 'Valor/Hora';
  static const dayOfWeek = 'Dia da Semana';
  static const afterXSchedule = 'Após X horário';
  static const afterXHours = 'Após X horas de trabalho';
  static const selectSchedule = 'Selecionar horário';
  static const newEditRuleWarning = 'Todos os campos têm que ser preenchidos.';
  static const deleteRuleMsg = 'Tem a certeza que pretende apagar esta regra?';
  static const updateRuleMsg = 'Regra atualizada com sucesso';
  static const insertRuleMsg = 'Regra criada com sucesso';
  static const unsavedChangesMsg =
      'Tem dados por Guardar. Pretende continuar sem guardar?';
  static const workStartsAt = 'Início do trabalho';
}

class DaysOfWeek {
  static const monday = 'Segunda';
  static const tuesday = 'Terça';
  static const wednesday = 'Quarta';
  static const thursday = 'Quinta';
  static const friday = 'Sexta';
  static const saturday = 'Sábado';
  static const sunday = 'Domingo';
}

class AnalysisViewMode {
  static const week = 'Semana';
  static const month = 'Mês';
  static const year = 'Ano';
}

class AppThemeOptions {
  static const automatic = 'Automático';
  static const dark = 'Escuro';
  static const light = 'Claro';
}
