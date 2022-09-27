import ballerina/graphql;
//create graphql listener and provide the port number to which it is listening
import ballerina/http;

public service class Covid19Entry {
    private string Date;
    private string Region;
    private decimal Deaths;
    private decimal Confirmed_Cases;
    private decimal Recoveries;
    private decimal Tested;

function init(string Date, string Region,decimal Deaths,decimal Confirmed_Cases,decimal Recoveries,decimal Tested) {
  self.Date = Date;
        self.Region = Region;
        self.Deaths = Deaths;
        self.Confirmed_Cases = Confirmed_Cases;
        self.Recoveries= Recoveries;
        self.Tested = Tested;

    }
    resource function get Date () returns string{
        return self.Date;  
    }
    resource function get Region() returns string{
        return self.Region;  
    }
    resource function get Deaths() returns decimal?{
        if self.Deaths is decimal{
            return self.Deaths/1000;
        }  
    }
    resource function get Confirmed_Cases() returns decimal?{
        if self.Confirmed_Cases is decimal{
            return self.Confirmed_Cases/1000;
        }  

    }
    resource function get Recoveries() returns decimal?{
        if self.Recoveries is decimal{
            return self.Recoveries/1000;
        }  
    }
    resource function get Tested() returns decimal?{
        if self.Tested is decimal{
            return self.Tested/1000;
        }  
    } 

    public function getDate() returns string{
        return self.Date;
    }
    public function getRegion () returns string{
        return self.Region;
    }
    public function getDeaths () returns decimal?{
        return self.Deaths;
    }
    public function getConfirmed_Cases () returns decimal?{
        return self.Confirmed_Cases;
    }
    public function getRecoveries () returns decimal?{
        return self.Recoveries;
    }
    public function getTested() returns decimal?{
        return self.Tested;
    }
    
    isolated function setDate(string Date) {
        self.Date = Date;
    } 
    isolated function setRegion(string Region) {
        self. Region = Region;
    }
    isolated function setDeaths(decimal Deaths){
        self.Deaths = Deaths;
    }
    isolated function setConfirmed_Cases(decimal Confirmed_Cases){
        self.Confirmed_Cases = Confirmed_Cases;
    }
    isolated function setRecoveries(decimal Recoveries){
        self.Recoveries = Recoveries;
    }
    isolated function setTested(decimal Tested){
        self.Tested = Tested;
    }
}

listener http:Listener httpListener = check new(9090);
     service /covid19 on new graphql:Listener(httpListener) {
     private Covid19Entry[] list; 
     function init(){
        self.list = [];
     }
     resource function get recordCases() returns Covid19Entry [] {
       return self.list;   
    }
     remote function addRecord(string date, string region,decimal deaths,decimal confirmed_cases,decimal recoveries,decimal tested){
        Covid19Entry newRecord = new ( date,  region, deaths, confirmed_cases, recoveries, tested);
        return self.list.push(newRecord);
     }
     remote function changeRecordDate(string date, string region) returns error?{
        Covid19Entry[] listDate = self.list.filter(item =>item.getRegion()==region);
        if listDate.length() !=1{
            return error(string `The record does not exist`);
        }
        else{
            return listDate[0].setDate(date);
        }
     }
     remote function changeRecordDeaths(string region, decimal deaths) returns error?{
        Covid19Entry[] listDate = self.list.filter(item =>item.getDeaths()==deaths);
        if listDate.length() !=1{
            return error(string `The record does not exist`);
        }
        else{
            listDate[0].setDeaths(deaths);
        }
     }
     remote function changeRecordConfirmedCases(string region, decimal Confirmed_Cases ) returns error?{
        Covid19Entry[] listDate = self.list.filter(item =>item. getConfirmed_Cases()==Confirmed_Cases);
        if listDate.length() !=1{
            return error(string `The record does not exist`);
        }
        else{
            listDate[0].setConfirmed_Cases(Confirmed_Cases);
        }
     }
     remote function changeRecordRecoveries(string region, decimal recoveries) returns error?{
        Covid19Entry[] listDate = self.list.filter(item =>item. getRecoveries()==recoveries);
        if listDate.length() !=1{
            return error(string `The record does not exist`);
        }
        else{
            listDate[0].setRecoveries(recoveries);
        }
     }
 } 