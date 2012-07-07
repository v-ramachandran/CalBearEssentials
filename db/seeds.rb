#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require "csv"

SRC_DIR= "db/init_data/"

R = ["db/init_data/Degree.csv","db/init_data/Requirement.csv"]
Degree.delete_all
Degree.create!(:name => "EECS")
Degree.create!(:name => "CS")

Requirement.delete_all
CourseRequirement.delete_all
UnitRequirement.delete_all

CourseRequirement.create!(:name => "EECS_Core_Courses", :units => 5)
CourseRequirement.create!(:name => "CS_Core_Courses", :units => 4)
CourseRequirement.create!(:name => "Upper_Div_EECS_Electives", :units => 6)
CourseRequirement.create!(:name => "Senior_Design_Class", :units => 1)
CourseRequirement.create!(:name => "Upper_Div_CS_Electives", :units => 5)
UnitRequirement.create!(:name => "Upper_Div_EECS_Electives_Units", :units => 20)
UnitRequirement.create!(:name => "Technical_Engineering_Courses", :units => 45)

def isnum(val)
  return val.to_i.to_s==val || val.to_s.to_i==val
end

def createModelObjects(file_name, class_name)
  # get the file path
  file_path = SRC_DIR+file_name
  s = "Waiting..."

  # check if it already has been produced
  unless R.include? file_path

    # Obtain the class name
    myClass=ActiveRecord::Base.const_get(class_name)

    # Remove all of the objects existing in the table now..
    deleted = myClass.count.to_s
    myClass.delete_all
    d_notice = "Deleted "+deleted+ " entries from "+class_name+" table!"
    puts d_notice

    # Get the necessary file_path
    file_path = SRC_DIR+file_name
    n = 0

    # Output each line
    CSV.foreach(file_path,
                :headers => :first_row,
                :header_converters => :symbol,
                :converters => :numeric ) do |line|
      to_create={}
      headers = line.headers
      value = line.to_hash.values
      value=value.map do |val|
        if isnum(val)
          val
        else
          val.gsub(" ","_")
        end
      end
      i=0
      headers.each do |header|
        sp = header.to_s.split("_")
        if sp[0]=="fky"
          # recursive call
          cname = sp[1].capitalize
          fname = cname+".csv"
          fpath = SRC_DIR+fname
          unless R.include? fpath
            createModelObjects(fname,cname)
          else
            dup_s= "Already created objects for "+cname+" table...So skipping."
            puts dup_s
          end
          # get the appropriate value from the model
          attr = sp[2..-1].join
          find_req = "find_by_"+attr.to_s
          model_class = ActiveRecord::Base.const_get(cname)
          val = model_class.send(find_req.to_sym, value[i]).id
          if isnum(val)
            val=val.to_i
          end
          temp_h=sp[1]+"_id"
          to_create[temp_h.to_sym]=val
          #
        else
          to_create[header.to_sym]=value[i]
        end
        i=i.send(:+,1)
      end
      myClass.create!(to_create)
      n = n + 1
    end
    s= "Created "+n.to_s+" objects in "+class_name+" table!"
    R << file_path

    # if it has then don't create again...
  else
    s= "Already created objects for "+class_name+" table...So skipping."
  end
  puts s
end

Dir.foreach(SRC_DIR) do |file_name|
  unless File.directory? file_name
    temp = file_name.split(".")
    if temp.length==2 && temp[1]=="csv"
      class_name = temp[0]
      createModelObjects(file_name, class_name)
    else
      puts "So.."+file_name+" isn't a CSV file. Can I get a proper file for seeding? It has to be a CSV file."
    end
  end
end

