module PlannableMod
  def self.included(base)
    base.has_many :future_planners, :class_name => "FuturePlanner"
    base.has_many :past_planners, :class_name => "PastPlanner"
  end
end
