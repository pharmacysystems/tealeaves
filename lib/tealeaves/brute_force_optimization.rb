module TeaLeaves
  class BruteForceOptimization
    INITIAL_PARAMETER_VALUES = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0].freeze
    
    def initialize(time_series, period, opts={})
      @time_series = time_series
      @period = period
      @opts = opts
    end


    def optimize
      [0.1, 0.5, 0.25, 0.125, 0.0625, 0.03125, 0.015625].inject(optimum(initial_models)) do |model, change|
        improve_model(model, change)
      end
    end

    def initial_test_parameters
      parameters = []

      INITIAL_PARAMETER_VALUES.each do |alpha|
        parameters << {alpha: alpha, beta: nil, gamma: nil, trend: :none, seasonality: :none}

        INITIAL_PARAMETER_VALUES.each do |beta|
          parameters << {alpha: alpha, beta: beta, gamma: nil, trend: :additive, seasonality: :none} if has_additive_trend? && has_no_seasonality?
          parameters << {alpha: alpha, beta: beta, gamma: nil, trend: :multiplicative, seasonality: :none} if has_multiplicative_trend? && has_no_seasonality?
          parameters << {alpha: alpha, beta: nil, gamma: beta, trend: :none, seasonality: :additive} if has_no_trend? && has_additive_seasonality?
          parameters << {alpha: alpha, beta: nil, gamma: beta, trend: :none, seasonality: :multiplicative} if has_no_trend? && has_multiplicative_seasonality?

          INITIAL_PARAMETER_VALUES.each do |gamma|
            parameters << {alpha: alpha, beta: beta, gamma: gamma, trend: :additive, seasonality: :additive} if has_additive_trend? && has_additive_seasonality?
            parameters << {alpha: alpha, beta: beta, gamma: gamma, trend: :additive, seasonality: :multiplicative} if has_additive_trend? && has_multiplicative_seasonality?
            parameters << {alpha: alpha, beta: beta, gamma: gamma, trend: :multiplicative, seasonality: :additive} if has_multiplicative_trend? && has_additive_seasonality?
            parameters << {alpha: alpha, beta: beta, gamma: gamma, trend: :multiplicative, seasonality: :multiplicative} if has_multiplicative_trend? && has_multiplicative_seasonality?
          end
        end
      end

      parameters
    end

    private

    def improve_model(model, change)
      trend_operations = model.trend == :none ? [nil] : [:+, :-, nil]
      season_operations = model.seasonality == :none ? [nil] : [:+, :-, nil]
      permutations = [:+, :-, nil].product(trend_operations, season_operations)
      optimum(permutations.map do |(op_1,op_2,op_3)|
                new_opts = {}
                set_value(new_opts, :alpha, model, op_1, change)
                set_value(new_opts, :beta, model, op_2, change)
                set_value(new_opts, :gamma, model, op_3, change)
                model.improve(new_opts)
              end)
    end

    def set_value(hsh, key, model, op, change)
      unless op.nil?
        new_value = model.send(key).send(op, change)
        if new_value >= 0.0 && new_value <= 1.0
          hsh[key] = new_value
        end
      end
    end

    def optimum(models)
      models.reject { |m| m.mean_squared_error.nan? }.min_by(&:mean_squared_error)
    end
    
    def initial_models
      initial_test_parameters.map do |parameters|
        ExponentialSmoothingForecast.new(@time_series, @period, parameters)
      end
    end

    def has_no_trend?
      @opts[:trend] == :none || @opts[:trend].nil?
    end

    def has_additive_trend?
      @opts[:trend] == :additive || @opts[:trend].nil?
    end

    def has_multiplicative_trend?
      @opts[:trend] == :multiplicative || @opts[:trend].nil?
    end

    def has_no_seasonality?
      @opts[:seasonality] == :none || @opts[:seasonality].nil?
    end

    def has_additive_seasonality?
      @opts[:seasonality] == :additive || @opts[:seasonality].nil?
    end

    def has_multiplicative_seasonality?
      @opts[:seasonality] == :multiplicative || @opts[:seasonality].nil?
    end
  end
end
