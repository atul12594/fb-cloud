require 'json'
require 'rubygems'
#begin
@log.trace("Started executing 'flint-hyperv:hyperv_2012:start_virtual_machine.rb' flintbit...")
begin
#Flintbit Input Parameters
#Mandatory
@connector_name= @input.get("connector_name")											#Name of the Connector
@vmname = @input.get("vmname")															#Name of the vm
@command = "powershell -Command \"&{start-vm -name #{@vmname} 2>&1 | ConvertTo-JSON}\"" #Command to execute
@protocol = @input.get("protocol")                                                      #Protocol
#optional
@hostname = @input.get("hostname")                          							#hostname
@password = @input.get("password")                              						#password
@user = @input.get("user")																#username
@request_timeout= @input.get("timeout")
@action = "exe"
@port = @input.get("port")                     							#timeout

@log.info("Flintbit input parameters are, connector name :: #{@connector_name} |
	                                         command ::       #{@command}|
                                           protocol ::      #{@protocol} |
                                           hostname ::      #{@hostname}|
                                           user ::          #{@user}|
                                           password ::      #{@password}|
                                           timeout ::       #{@request_timeout}")

if @vmname == nil || @vmname == ""
		@log.error("Please provide vm name to perform start operation")
		@output.exit(1,"vm name is blank or not provided")
end

connector_call = @call.connector(@connector_name)
                      .set("command",@command)
                      .set("protocol",@protocol)
                      .set("action",@action)
                      .set("hostname",@hostname)
                      .set("user",@user)
                      .set("password",@password)
                      .set("port",@port)
                      .set("timeout",10000)

if @request_timeout.nil? || @request_timeout.is_a?(String)
   @log.trace("Calling #{@connector_name} with default timeout...")
	 response = connector_call.sync
else
   @log.trace("Calling #{@connector_name} with given timeout #{request_timeout.to_s}...")
	 response = connector_call.timeout(@request_timeout).sync
end
@log.info(">>>>>>>>>>>>>>>>>#{response}")
#Winrm Connector Response Meta Parameters
response_exitcode=response.exitcode           #Exit status code
response_message=response.message             #Execution status message
#@log.info("111111111111111#{response_exitcode}")
#@log.info("2222222222222#{response_message}")
#Winrm Connector Response Parameters
result = response.get("output")               #Response Body


if response.exitcode == 0

    @log.info("output"+result.to_s)
	@log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} |
    	                                                   message ::  #{response_message}")
	#@res = @util.json(result.to_s)
    #@output.setraw("output",result.to_s)
    @output.set('exit-code', 0).set('message', response_message).set('output',result)


else
  @log.info("output"+result.to_s)
	@log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} |
		                                                  message ::  #{response_message}")
    #@output.exit(1,response_message)
    @output.set('exit-code', 1).set('message', response_message).set('output',result)
    end
  rescue Exception => e
  @log.error(e.message)
  @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'flint-hyperv:hyperv_2012:start_virtual_machine.rb' flintbit...")
#end
