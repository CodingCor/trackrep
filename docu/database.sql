drop database if exists trackrep;
create database trackrep
    default character set  = "utf8mb4"
    default collate = "utf8mb4_general_ci";

use trackrep;

create table exercise (
    id int not null auto_increment,
    name varchar(60) not null,
    constraint pk_exercise primary key(id),
    constraint uk_exercise_name unique key(name)
);

create table exercise_log (
    logdate date not null,
    logtime time not null,
    exercise int not null,
    value int,
    constraint pk_exercise_log primary key(logdate, logtime, exercise),
    constraint fk_exercise foreign key(exercise) 
        references exercise(id)
        on delete restrict
        on update cascade
);

-- test data here

insert into exercise (name) values 
    ("Push Up"),
    ("Wall Hand Stand Push Up"),
    ("Pull Up"),
    ("Chin Up"),
    ("Side Raises");

insert into exercise_log (logdate, logtime, exercise, value) values
    ("2023-08-15", "11:46:00", 1, 12),
    ("2023-08-15", "11:46:20", 1, 12),
    ("2023-08-15", "11:47:00", 1, 12),
    ("2023-08-15", "11:43:00", 1, 12),
    ("2023-08-15", "11:48:00", 1, 12);

