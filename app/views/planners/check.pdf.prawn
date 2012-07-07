
unitReqs = Planner.find_unit_requirements_fulfilled(current_user)
courseReqs = Planner.find_course_requirements_fulfilled(current_user)
#unitReqs = {"req1" => [[{"name" => "Discrete Math","units" => 4}],4,false,8]}
#courseReqs = {"req2" => [[{"name" => "UI","units" => 4}, {"name" => "Software Engineering","units" => 4}],2,true,2]}
unitReqNames = unitReqs.keys
courseReqNames = courseReqs.keys


pdf.text "<font name='Helvetica'><b>Degree Progress Report</b></font>", :size => 30, :inline_format => true
pdf.move_down(20)
pdf.text "<i> <b> Name: </b> #{current_user.first_name} #{current_user.last_name}  <b> Degree: </b> #{current_user.degree.name} </i>", :size =>20, :inline_format => true
pdf.move_down(35)

pdf.text "<b> Unit Requirements</b>:", :size =>20, :inline_format => true
pdf.move_down(10)

unitReqNames.each do |rName|
  tempString = ""
  elem = unitReqs[rName]
  if elem[2]
    pdf.fill_color = "00ff00"
  	tempString = "Completed - "
  else
  	pdf.fill_color = "ff0000"
  end
  tempString = tempString + rName + " (" + elem[1].to_s() + "/" + elem[3].to_s() + " units completed)"
  pdf.text tempString, :size => 18
  pdf.fill_color "000000"
  pdf.move_down(10)
  pdf.indent(10) do
    elem[0].each do |course|
      courseElem = Course.find_by_name(course["name"].gsub(" ","_"))
      pdf.text "   " + courseElem.abb.to_s().gsub("_"," ") + " " + course["name"] + " (" + course["units"].to_s() + " units)", :size => 12
      pdf.move_down(7)
    end
    pdf.move_down(3)
  end
  pdf.move_down(5)
end
pdf.move_down(10)

pdf.text "<b> Course Requirements</b>:", :size =>20, :inline_format => true
pdf.move_down(10)


courseReqNames.each do |rName|
  tempString = ""
  elem = courseReqs[rName]
  if elem[2]
    pdf.fill_color = "00ff00"
  	tempString = "Completed - "
  else
  	pdf.fill_color = "ff0000"
  end
  tempString = tempString + rName + " (" + elem[1].to_s() + "/" + elem[3].to_s() + " courses completed)"
  pdf.text tempString, :size => 18
  pdf.fill_color = "000000"
  pdf.move_down(10)
  pdf.indent(10) do
    elem[0].each do |course|
      courseElem = Course.find_by_name(course["name"].gsub(" ","_"))
      pdf.text "   " + courseElem.abb.to_s().gsub("_"," ") + " " + course["name"] + " (" + course["units"].to_s() + " units)", :size => 12
      pdf.move_down(7)
    end
    pdf.move_down(3)
  end
end
