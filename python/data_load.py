import os
import requests
import pandas as pd
import psycopg2
import os
from credentials import *
from api_endpoint import *

os.chdir(os.path.dirname(os.path.abspath(__file__)))


def main():

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