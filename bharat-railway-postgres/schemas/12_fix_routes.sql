INSERT INTO train_master_schema.routes (train_number, station_code, sequence_number, arrival_time, departure_time, halt_duration, distance_from_origin, day_number, is_commercial_stop, is_originating_station, is_terminating_station, is_major_junction, booking_quota, waiting_list_quota) VALUES
('12030','ASR',1,NULL,'06:00',0,0,1,true,true,false,true,100,30),
('12030','JAT',2,'08:30','08:35',5,210,1,true,false,false,true,40,10),
('12030','UMB',3,'11:00','11:05',5,380,1,true,false,false,true,40,10),
('12030','NDLS',4,'13:30',NULL,0,448,1,true,false,true,true,0,0),
('12029','NDLS',1,NULL,'06:00',0,0,1,true,true,false,true,100,30),
('12029','UMB',2,'08:30','08:35',5,200,1,true,false,false,true,40,10),
('12029','JAT',3,'11:00','11:05',5,380,1,true,false,false,true,40,10),
('12029','ASR',4,'13:30',NULL,0,448,1,true,false,true,true,0,0),
('12430','SBC',1,NULL,'20:00',0,0,1,true,true,false,true,100,40),
('12430','SC',2,'05:30','05:40',10,700,2,true,false,false,true,80,30),
('12430','NGP',3,'13:00','13:10',10,1280,2,true,false,false,true,60,20),
('12430','BPL',4,'18:00','18:10',10,1650,2,true,false,false,true,60,20),
('12430','NZM',5,'05:00',NULL,0,2365,3,true,false,true,true,0,0),
('12723','HYB',1,NULL,'21:00',0,0,1,true,true,false,true,120,40),
('12723','SC',2,'21:30','21:40',10,10,1,true,false,false,true,60,20),
('12723','NGP',3,'06:00','06:10',10,800,2,true,false,false,true,60,20),
('12723','BPL',4,'12:00','12:10',10,1180,2,true,false,false,true,60,20),
('12723','NDLS',5,'21:00',NULL,0,1670,2,true,false,true,true,0,0),
('12724','NDLS',1,NULL,'21:00',0,0,1,true,true,false,true,120,40),
('12724','BPL',2,'06:00','06:10',10,690,2,true,false,false,true,60,20),
('12724','NGP',3,'12:00','12:10',10,1070,2,true,false,false,true,60,20),
('12724','SC',4,'20:00','20:10',10,1660,2,true,false,false,true,60,20),
('12724','HYB',5,'21:00',NULL,0,1670,2,true,false,true,true,0,0),
('12955','BCT',1,NULL,'18:00',0,0,1,true,true,false,true,100,40),
('12955','ADI',2,'00:30','00:40',10,490,2,true,false,false,true,60,20),
('12955','AII',3,'06:00','06:10',10,850,2,true,false,false,true,50,20),
('12955','JP',4,'10:00',NULL,0,1159,2,true,false,true,true,0,0),
('12956','JP',1,NULL,'18:00',0,0,1,true,true,false,true,100,40),
('12956','AII',2,'22:00','22:10',10,309,1,true,false,false,true,50,20),
('12956','ADI',3,'04:00','04:10',10,669,2,true,false,false,true,60,20),
('12956','BCT',4,'10:30',NULL,0,1159,2,true,false,true,true,0,0)
ON CONFLICT DO NOTHING;

/*
=============================================================================
DUMMY / DEMO DATA - MISSING ROUTE FIX (batch 2)
The trains below already existed in 11_seed_data.sql (train_master_schema.trains)
but had ZERO rows in train_master_schema.routes, so they could never appear
in a station-to-station search. This adds a plausible multi-stop route for
each, using their own already-defined origin/destination and total_distance.
No schema/constraint changes - additive INSERTs only.
=============================================================================
*/

INSERT INTO train_master_schema.routes (train_number, station_code, sequence_number, arrival_time, departure_time, halt_duration, distance_from_origin, day_number, is_commercial_stop, is_originating_station, is_terminating_station, is_major_junction, booking_quota, waiting_list_quota) VALUES
('12952', 'NDLS', 1, NULL, '21:44', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12952', 'BRC', 2, '04:44', '04:49', 5, 631, 2, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12952', 'BCT', 3, '13:12', NULL, 0, 1386, 2, TRUE, FALSE, TRUE, TRUE, 0, 0),
('12423', 'NDLS', 1, NULL, '15:51', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12423', 'PNBE', 2, '03:28', '03:33', 5, 872, 2, TRUE, FALSE, FALSE, FALSE, 60, 20),
('12423', 'GHY', 3, '12:03', '12:13', 10, 1510, 2, TRUE, FALSE, FALSE, FALSE, 60, 20),
('12423', 'DBRG', 4, '00:33', NULL, 0, 2435, 3, TRUE, FALSE, TRUE, TRUE, 0, 0),
('12002', 'BPL', 1, NULL, '16:34', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12002', 'AGC', 2, '20:26', '20:31', 5, 329, 1, TRUE, FALSE, FALSE, FALSE, 60, 20),
('12002', 'NDLS', 3, '00:57', NULL, 0, 707, 2, TRUE, FALSE, TRUE, TRUE, 0, 0),
('12009', 'ADI', 1, NULL, '18:33', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12009', 'BRC', 2, '20:39', '20:44', 5, 164, 1, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12009', 'ST', 3, '22:20', '22:30', 10, 290, 1, TRUE, FALSE, FALSE, FALSE, 60, 20),
('12009', 'BCT', 4, '01:06', NULL, 0, 493, 2, TRUE, FALSE, TRUE, TRUE, 0, 0),
('12909', 'NZM', 1, NULL, '09:33', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12909', 'BRC', 2, '17:12', '17:17', 5, 536, 1, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12909', 'BDTS', 3, '05:09', NULL, 0, 1367, 2, TRUE, FALSE, TRUE, TRUE, 0, 0),
('12839', 'HWH', 1, NULL, '13:43', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12839', 'BBS', 2, '20:58', '21:03', 5, 399, 1, TRUE, FALSE, FALSE, FALSE, 60, 20),
('12839', 'VSKP', 3, '05:49', '05:59', 10, 882, 2, TRUE, FALSE, FALSE, FALSE, 60, 20),
('12839', 'BZA', 4, '12:06', '12:11', 5, 1219, 2, TRUE, FALSE, FALSE, FALSE, 60, 20),
('12839', 'MAS', 5, '20:14', NULL, 0, 1662, 2, TRUE, FALSE, TRUE, TRUE, 0, 0),
('11015', 'LTT', 1, NULL, '00:55', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('11015', 'BPL', 2, '11:44', '11:49', 5, 595, 1, TRUE, FALSE, FALSE, TRUE, 60, 20),
('11015', 'LKO', 3, '00:16', '00:26', 10, 1280, 2, TRUE, FALSE, FALSE, FALSE, 60, 20),
('11015', 'GKP', 4, '07:42', NULL, 0, 1680, 2, TRUE, FALSE, TRUE, TRUE, 0, 0),
('12345', 'HWH', 1, NULL, '17:45', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12345', 'GHY', 2, '11:55', NULL, 0, 1000, 2, TRUE, FALSE, TRUE, TRUE, 0, 0),
('12627', 'SBC', 1, NULL, '01:39', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12627', 'GTL', 2, '11:35', '11:40', 5, 745, 1, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12627', 'SC', 3, '17:52', '18:02', 10, 1210, 1, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12627', 'BPL', 4, '03:30', '03:35', 5, 1920, 2, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12627', 'NDLS', 5, '10:07', NULL, 0, 2410, 2, TRUE, FALSE, TRUE, TRUE, 0, 0),
('12628', 'NDLS', 1, NULL, '01:56', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12628', 'BPL', 2, '08:32', '08:37', 5, 495, 1, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12628', 'SC', 3, '15:06', '15:16', 10, 982, 1, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12628', 'GTL', 4, '22:31', '22:36', 5, 1526, 1, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12628', 'SBC', 5, '10:23', NULL, 0, 2410, 2, TRUE, FALSE, TRUE, TRUE, 0, 0),
('12957', 'ADI', 1, NULL, '23:09', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12957', 'JP', 2, '03:45', '03:50', 5, 392, 2, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12957', 'NDLS', 3, '10:12', NULL, 0, 934, 2, TRUE, FALSE, TRUE, TRUE, 0, 0),
('12213', 'YPR', 1, NULL, '04:21', 0, 0, 1, TRUE, TRUE, FALSE, TRUE, 60, 20),
('12213', 'GTL', 2, '11:22', '11:27', 5, 632, 1, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12213', 'SC', 3, '17:35', '17:45', 10, 1185, 1, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12213', 'BPL', 4, '00:28', '00:33', 5, 1790, 2, TRUE, FALSE, FALSE, TRUE, 60, 20),
('12213', 'NDLS', 5, '06:56', NULL, 0, 2365, 2, TRUE, FALSE, TRUE, TRUE, 0, 0)
ON CONFLICT DO NOTHING;

