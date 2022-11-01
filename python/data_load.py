import os
import requests
import pandas as pd
import psycopg2
from credentials import *
from api_endpoint import *

#set working directory to .py file current directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))


def main():
    #retrieves a list of api endpoints from api_endpoint.py and iterates through them,
    #writing them to postgres instance defined in credentials.py
    #run the schema_init.sql file against the instance before running this code

    for source in sources:

        r = requests.request('GET', source["URL"], headers=auth_header, verify=False)
        df = pd.DataFrame(r.json())
        df['payload'].to_csv('%s.csv' % source['destination'], index=False, header=False)
        writeDataFrameToDB(df, source['destination'])


def writeDataFrameToDB(df, destination):

    try:

        con=psycopg2.connect(dbname=credentials['database'],
                            host=credentials['host'],
                            port=credentials['port'],
                            user=credentials['user'],
                            password=credentials['password'],
                            options=f'-c search_path=raw_data')
        con.autocommit=True
        cur=con.cursor()

        f=open('%s.csv' % destination, 'r')
        cur.copy_from(f, destination)
        f.close()

    except Exception as e:

        print(e)
        pass


    finally:

        cur.close()
        con.close()

if __name__ == "__main__":
	main()