#!/bin/bash
#
# Count users on Mailman lists, over time; see how many are @redhat.com
#
#  Copyright 2012 Karsten Wade kwade@redhat.com quaid@iquaid.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
# CSV fields: "list_name","subscriber_count","redhat_subscriber_count","date"

# Variables
MMBIN="/usr/lib/mailman/bin"
LIST="/tmp/all-mailman-lists"
DATE=`/bin/date +%Y%m%d`
COUNT="/tmp/subscriber-count"
RHTCOUNT="/tmp/redhat-subscriber-count"
DATASTORE="/root/mailman-data"

# Generate list of all lists
$MMBIN/list_lists -b > $LIST

# For each list, get current subscriber count, and inject results 
# with date in to individual CSV files (one per list)
for i in `cat $LIST`;
	do $MMBIN/list_members $i | wc -l > $COUNT;
	# debug array
	# cat /tmp/subscriber-count;
	$MMBIN/list_members $i | grep "redhat.com" | wc -l > $RHTCOUNT;
        # debug array
        #cat /tmp/redhat-subscriber-count;
	echo $i","`cat $COUNT`","`cat $RHTCOUNT`","$DATE >> $DATASTORE/$i-subscriber-count.csv
	done

