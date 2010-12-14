module Recurs
  #module Consts
    #  0       1         2          3           4         5        6
    DAYS              = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    MONTHS            = ['January', "February", 'March', 'April', 'May', 'June',
                         'July', 'August', 'September', 'October', 'November', 'December']
    BY_N_SECONDS      = (0..59).to_a
    BY_N_MINUTES      = (0..59).to_a
    BY_N_HOURS        = (0..23).to_a
    BY_N_DAYS         = (0..6).to_a
    BY_N_MONTH_DAYS   = (1..31).to_a
    BY_N_YEAR_DAYS    = (1..366).to_a
    BY_DAYS           = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA']
    BY_N_WEEKS        = (1..54).to_a
    BY_N_MONTHS       = (1..12).to_a
    BY_MONTHS         = ['jan', 'feb', 'mar', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']

    #SYM_DAYS = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
    SYM_INTEGERS      = [:zero, :one, :two, :three, :four, :five, :six, :seven, :eight, :nine, :ten]
    SYM_TEENS         = [:eleven, :twelve, :thirteen, :fourteen, :fifteen, :sixteen, :seventeen, :eighteen, :nineteen]
    SYM_INTEGER_GROUP = SYM_INTEGERS+SYM_TEENS

    # SYM_TENS[(34 - 34.modulo(10))/10]
    SYM_TENS          = [:ten, :twenty, :thirty, :fourty, :fifty, :sixty, :seventy, :eighty, :ninety, :hundred]

    def get_integer_from_sym(sym)
      SYM_INTEGER_GROUP(sym)
    end

    def build_num_sym(int)
      if int > 19
        r = int.modulo(10)
        t = int - r
        [SYM_TENS(t), SYM_INTEGERS[r]]
      else
        SYM_INTEGER_GROUP[int]
      end
    end
  #end
end