import roslibpy
import logging
import json
import time
import requests


client = roslibpy.Ros(host='localhost', port=9090)

ActionListener = roslibpy.Topic(client, '/ros_out', 'rosplan_dispatch_msgs/ActionDispatch') #listens to action when called for execution
talker = roslibpy.Topic(client, '/ros_in', 'std_msgs/String') #common topic to reply acknoledgment



def start_listening():
    ActionListener.subscribe(receive_message)
    return

def receive_message(message):
    #print('Heard talking: ' + json.dumps(message))
    print('Nags:'+ message['name'])
    start_talking(message)
    return


def start_talking(message):
    if(client.is_connected):
        #time.sleep(0.5)
        uploadString = "ActionName: "+ message['name']+ " "+"ActionId: "+ str(message['action_id'])
        appiot_call(uploadString)
        talker.publish(roslibpy.Message({'data': 'Acknowledged'}))
        print('Sending message...')
        #time.sleep(2)
    return

def appiot_call(actionname):
      #specify url
      url = 'https://lab.api.iot-accelerator.ericsson.net/ddm/api/v3/resources/8bf797a5-c14c-4197-a28c-308ba5f0fd45/write'

      data = {
      "Id": "8bf797a5-c14c-4197-a28c-308ba5f0fd45",
      "Value": actionname
      }

      headers = {'Authorization': 'Basic MmE0ZDQ4ODQtYzc1My00ZDM4LTg5NmEtZWYyY2E5NzVmY2YyQDViMDZhMTdhLTI3ZTctNDcwYy1hZjZiLWMzOTMxY2E1ZTExZDpSellkMVlOVGtPdlc2T1gz ','X-DeviceNetwork': '613b7124-e2db-4e76-9feb-102a869bd497','Accept': 'text/plain','Content-Type': 'application/json'}

      #Call REST API
      response = requests.put(url, data=json.dumps(data), headers=headers)

      #Print Response
      print(response.text)
      #time.sleep(2)
      return



client.on_ready(start_listening)
client.run_forever()