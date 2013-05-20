# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
admin = User.create!(name: 'admin', password: 'adminadmin', admin: true)
liuhui = User.create!(name: 'liuhui', password: 'liuhui')
qinfanpeng = User.create!(name: 'qinfanpeng', password: 'qinfanpeng')
p '-----------3 users was added ---------!'

GoodName.delete_all
GoodName.create!(name: '米')
GoodName.create!(name: '米价')
GoodName.create!(name: '米兰')
GoodName.create!(name: '阿基米德')
GoodName.create!(name: '油')
GoodName.create!(name: '石油')
GoodName.create!(name: '油价')
p '------------7 good namas was added ------------'
