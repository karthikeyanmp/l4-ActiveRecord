class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def self.due_today
    all.where("due_date = ?", Date.today) #due_date == Date.today
  end

  def overdue?
    due_date < Date.today
  end

  def self.overdue
    all.where("due_date < ?", Date.today) #due_date < Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def self.due_later
    all.where("due_date > ?", Date.today) #due_date > Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.add_task(task)
    create!(todo_text: task[:todo_text], due_date: Date.today + task[:due_in_days], completed: false)
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list"
    puts "\n"
    puts "Overdue"
    puts self.overdue.order(id: :asc).map { |todo| todo.to_displayable_string }
    #all.order(id: :asc).select do |todo|
    #  puts todo.to_displayable_string if todo.overdue?
    #end
    puts "\n"
    puts "Due Today"
    puts self.due_today.order(id: :asc).map { |todo| todo.to_displayable_string }
    #all.order(id: :asc).select do |todo|
    #  puts todo.to_displayable_string if todo.due_today?
    #end
    puts "\n"
    puts "Due Later"
    puts self.due_later.order(id: :asc).map { |todo| todo.to_displayable_string }
    #all.order(id: :asc).select do |todo|
    #  puts todo.to_displayable_string if todo.due_later?
    #end
  end

  def self.mark_as_complete!(todo_id)
    todo = find(todo_id)
    todo.completed = true
    todo.save
    todo
  end
end
