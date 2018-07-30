class MakersController < ApplicationController
  def index

   str = 
   [
    ["TOPIC", " publisher", " subscribers"],
    ["SRV", "clients", "servers"]
   ];

   name =
   [
    "tp[]",
    "ss[]",
   ];

   @str = str
   @name = name

  end

  def getVal(num, type)
     res = ""
     if 0 < num
       if type == "pub"
         res = "ros::Publisher "
       end
       if type == "sub"
         res = "ros::Subscriber "
       end
       if type == "srv"
         res = "ros::ServiceServer "
       end
       if type == "cli"
         res = "ros::ServiceClient "
       end
     end
     num.times do |i|
       res = res + type + i.to_s + ","
     end
     if 0 < num
        res[-1] = ";"
     end
     res
  end

  def getPub_init(num)
    res = ""
    num.times do |i|
      res = res + "pub" + i.to_s + "(nh.advertise<geometry_msgs::Twist>(\"topic" + i.to_s + "\", 1000)),\n"
    end
    res
  end

  def getSub_init(num)
    res = ""
    num.times do |i|
      res = res + "sub" + i.to_s + "(nh.subscribe(\"topic" + i.to_s + "\", 1000, &RosTmp_c::sub" + i.to_s + "_CB, this)),\n"
    end
    res
  end

  def getCli_init(num)
    res = ""
    num.times do |i|
      res = res + "cli" + i.to_s + "(nh.serviceClient<std_srvs::Empty>(\"server" + i.to_s + "\")),\n"
    end
    res
  end

  def getSrv_init(num)
    res = ""
    num.times do |i|
      res = res + "srv" + i.to_s + "(nh.advertiseService(\"server" + i.to_s + "\", &RosTmp_c::ss"+i.to_s+", this)),\n"
    end
    res
  end

  def getSub_cb(num)
    res = ""
    num.times do |i|
      res = res + "\nvoid sub" + i.to_s + "_CB(const geometry_msgs::Twist::ConstPtr &msg)\n{\n\n}\n"
    end
    res
  end

  def getServer(num)
    res = ""
    num.times do |i|
      res = res + "\nbool ss" + i.to_s + "(std_srvs::Empty::Request &req, std_srvs::Empty::Response &res)\n{\n  return true;\n}\n"
    end
    res
  end

  def calc
#例のアレを作成
    tp = params[:tp]
    ss = params[:ss]

    str =       "#include <ros/ros.h>\n"
    str = str + "#include <geometry_msgs/Twist.h>\n"
    str = str + "#include <std_srvs/Empty.h>\n"
    str = str + "\n"
    str = str + "using namespace std;\n"
    str = str + "\n"
    str = str + "class RosTmp_c\n"
    str = str + "{\n"
    str = str + "public:\n\n"
    str = str + "RosTmp_c():\n"
    str = str + getPub_init(tp[0].to_i)
    str = str + getSub_init(tp[1].to_i)
    str = str + getCli_init(ss[0].to_i)
    str = str + getSrv_init(ss[1].to_i)
    str = str + " dummy(0){}\n"
    str = str + "\n"
    str = str + "private:\n"
    str = str + "\n int dummy;"
    str = str + "\n ros::NodeHandle nh;\n"
    str = str + getVal(tp[0].to_i, "pub") + "\n"
    str = str + getVal(tp[1].to_i, "sub") + "\n"
    str = str + getVal(ss[0].to_i, "cli") + "\n"
    str = str + getVal(ss[1].to_i, "srv") + "\n"
    str = str + "\n"
    str = str + getSub_cb(tp[1].to_i) + "\n"
    str = str + getServer(ss[1].to_i) + "\n"
    str = str + "\n"
    str = str + "};\n\n"
    str = str + "main(int c, char **v)\n{\n ros::init(c, v, \"template_node\");\n"
    str = str + " ros::Time::init();\n "
    str = str + " RosTmp_c obj;\n\n ros::spin();\n//while(ros::ok()) obj.spin(), ros::spinOnce();\n"
    str = str + "}"

    @str = str
#    @str = "#include <iostream>\n\nusing namespace std;"
#    @str = @str.delete("\"").delete("[").delete("]").gsub(/(\r|\n|\r\n)/, "\\\n")

    redirect_to :action => 'res', :str => @str
  end

  def res
    @str = params[:str]
  end
end
