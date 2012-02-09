# -*- encoding: utf-8 -*-
require 'mongo'

module Mongodb
  module Testdata
    class Factory
      module WorldWideBusinessMixins
        attr_accessor :options

        def initialize(options)
          raise ArgumentError.new("Options needs to be an array!") unless options.is_a?(Array)
          @options = options
        end

        def rec_path(tree, leaf, reversed)
          raise ArgumentError.new("'Tree' needs a to be a hash!") unless tree.is_a?(Hash)
          return [] if leaf.nil?

          if reversed
            [leaf.to_s] + self.rec_path(tree, tree[leaf], reversed)
          else
            self.rec_path(tree, tree[leaf], reversed) + [leaf.to_s]
          end
        end

        def get_path(tree, leaf, prefix, return_hsh = false, reversed = false)
          path = rec_path(tree, leaf, reversed)

          if( return_hsh )
            path = {}.tap do |hsh|
              path.each_with_index{|element, i| hsh[prefix+i.to_s] = element}
            end
          end

          return path
        end

        #def do_save!(obj)
        #  WorldWideBusiness.mongo_collection.insert(create_insert_hsh(obj))
        #end

        def to_hash
          hsh = {}

          options.each do |option|
            hsh.merge!(path(option[:dimension], option[:value], true))
          end
          return hsh
        end
      end


      class WorldWideBusiness
        @@db_name         = 'qed_ruby_mongodb_test'
        @@mongo           = Mongo::Connection.new('127.0.0.1', 27017)
        @@db              = @@mongo.db(@@db_name)
        @@collection      = @@db.collection('world_wide_business')

        def self.mongo
          @@mongo
        end

        def self.db
          @@db
        end

        def self.mongo_collection
          @@collection
        end

        def self.startup(line_items = WORLD_WIDE_BUSINESS )
          line_items.each do |item|
            hsh = expanded_line_item_hsh(item[:line_item])

            item[:amount].times { WorldWideBusiness.mongo_collection.insert({:value => hsh}) }
          end
          sleep(0.4)
        end

        def self.sell_out
          WorldWideBusiness.mongo.drop_database(@@db_name)
        end

        class BusinessDevisionDimension
          include WorldWideBusinessMixins
          ALL             = "ALL"

          # Services or Goods
          SERVICES        = "SERVICES"
          GOODS           = "GOODS"

          # Main-Divisions
          SW_CONSULTING   = "SW_CONSULTING"
          AIRPLANES       = "AIRPLANES"
          FOOD            = "FOOD"
          PHARMA          = "PHARMA"
          E_COMMERCE      = "E_COMMERCE"

          # Devision
          MS              = "MS"
          JETPLANES       = "JETPLANES"
          BIO             = "BIO"
          GEN             = "GEN"
          COSMETICS       = "COSMETICS"
          DRUGS           = "DRUGS"
          PROPELLORPLANES = "PROPELLERPLANES"
          OWNER           = "OWNER"
          OTHER           = "OTHER"
          ORACLE          = "ORACLE"
          SAP             = "SAP"
          MINOR           = "MINOR"

          # Sub-Devisions
          DEV_M           = "DEV_M"
          UP1             = "UP1"
          UP2             = "UP2"
          OTHER1          = "OTHER1"
          DEV_O           = "DEV_O"
          MAINTENANCE_O   = "MAINTENANCE_O"
          LICENSES_O      = "LICENSES_O"
          DEV_S           = "DEV_S"
          MAINTENANCE_S   = "MAINTENANCE_S"
          LICENSES_S      = "LICENSES_S"
          MAINTENANCE_M   = "MAINTENANCE_M"
          LICENSES_M      = "LICENSES_M"
          UP4             = "UP4"
          UP5             = "UP5"
          UP6             = "UP6"
          OTHER2          = "OTHER2"

          DIMENSION_PREFIXES = {
              :devision => "DIM_DEV_"
          }

          DIMENSION_TREES   = {
            :devision  => {
                SERVICES      => ALL,
                GOODS         => ALL,
                SW_CONSULTING => SERVICES,
                E_COMMERCE    => SERVICES,
                AIRPLANES     => GOODS,
                FOOD          => GOODS,
                PHARMA        => GOODS,
                OWNER         => E_COMMERCE,
                OTHER         => E_COMMERCE,
                MINOR         => E_COMMERCE,
                ORACLE        => SW_CONSULTING,
                MS            => SW_CONSULTING,
                SAP           => SW_CONSULTING,
                JETPLANES     => AIRPLANES,
                DEV_M         => MS,
                BIO           => FOOD,
                GEN           => FOOD,
                COSMETICS     => PHARMA,
                DRUGS         => PHARMA,
                PROPELLORPLANES     => AIRPLANES,
                UP1           => OWNER,
                UP2           => OWNER,
                OTHER1        => OTHER,
                DEV_O         => ORACLE,
                MAINTENANCE_O => ORACLE,
                MAINTENANCE_S => SAP,
                LICENSES_S    => SAP,
                DEV_M         => MS,
                MAINTENANCE_M => MS,
                LICENSES_M    => MS,
                UP4           => MINOR,
                UP5           => MINOR,
                UP6           => MINOR,
                OTHER2        => OTHER

            }
          }

          def path(dimension, leaf, return_hsh = false, reversed = false)
            get_path(DIMENSION_TREES[dimension.to_sym], leaf, DIMENSION_PREFIXES[dimension.to_sym], return_hsh, reversed)
          end

          def save!
            do_save!(self)
          end
        end

        class GeographicDimension
          include WorldWideBusinessMixins

          ALL         = "ALL"
          EUROPE      = "EUROPE"
          ASIA        = "ASIA"
          AUSTRALIA   = "AUSTRALIA"
          AFRICA      = "AFRICA"
          NORTHAMERICA= "NORTHAMERICA"
          SOUTHAMERICA= "SOUTHAMERICA"
          DE          = "DE"
          TW          = "TW"
          AU          = "AU_C"
          LK          = "LK"
          CN          = "CN"
          US          = "US"
          FR          = "FR"
          UK          = "UK"
          VE          = "VE"
          ZA          = "ZA"
          MX          = "MX"
          CA          = "CA"
          BERLIN      = "BERLIN"
          HAMBURG     = "HAMBURG"
          TAIPEH      = "TAIPEH"
          CANBERRA    = "CANBERRA"
          COLOMBO     = "COLOMBO"
          GUANGZHOU   = "GUANGZHOU"
          SHANGHAI    = "SHANGHAI"
          CALIFORNIA  = "CALIFORNIA"
          NEWYORK     = "NEWYORK"
          NEYJERSEY   = "NEWJERSEY"
          FR3         = "FR3"
          LONDON      = "LONDON"
          MANCHASTER  = "MANCHASTER"
          LIVERPOOL   = "LIVERPOOL"
          BAYERN      = "BAYERN"
          FR2         = "FR2"
          CARACAS     = "CARACAS"
          JOHANNISBURG= "JOHANNISBURG"
          BEJING      = "BEJING"
          MEXICOCITY  = "MEXICOCITY"
          OTTOWA      = "OTTOWA"

          DIMENSION_PREFIXES = {
              :location => "DIM_LOC_"
          }

          # dimension tree for location
          DIMENSION_TREES = {
            :location => {
                # CONTINENTS
                EUROPE      => ALL,
                ASIA        => ALL,
                AUSTRALIA   => ALL,
                AFRICA      => ALL,
                NORTHAMERICA=> ALL,
                SOUTHAMERICA=> ALL,
                # COUNTRIES
                DE          => EUROPE,
                TW          => ASIA,
                AU          => AUSTRALIA,
                LK          => AFRICA,
                CN          => ASIA,
                US          => NORTHAMERICA,
                FR          => EUROPE,
                UK          => EUROPE,
                VE          => SOUTHAMERICA,
                ZA          => AFRICA,
                MX          => SOUTHAMERICA,
                CA          => NORTHAMERICA,
                # CITIES
                BERLIN      => DE,
                HAMBURG     => DE,
                TAIPEH      => TW,
                CANBERRA    => AU,
                COLOMBO     => LK,
                GUANGZHOU   => CN,
                SHANGHAI    => CN,
                CALIFORNIA  => US,
                NEWYORK     => US,
                NEYJERSEY   => US,
                FR3         => FR,
                LONDON      => UK,
                MANCHASTER  => UK,
                LIVERPOOL   => UK,
                BAYERN      => DE,
                FR2         => FR,
                CARACAS     => VE,
                JOHANNISBURG=> ZA,
                BEJING      => CN,
                MEXICOCITY  => MX,
                OTTOWA      => CA
            }
          }

          def path(dimension, leaf, return_hsh = false, reversed = false)
            get_path(DIMENSION_TREES[dimension.to_sym], leaf, DIMENSION_PREFIXES[dimension.to_sym], return_hsh, reversed)
          end

          def save!
            do_save!(self)
          end
        end

        class RevenueDimension
          include WorldWideBusinessMixins
          ALL                 = "ALL"
          GOODS               = "GOODS"
          ELECTRONICS         = "ELECTRONICS"
          SERVICE             = "SERVICE"
          A380                = "A380"
          CPLUSPLUS           = "C++"
          BEANS               = "BEANS"
          PEELER              = "PEELER"
          ASPIRINC            = "ASPIRINC"
          CESSNA162           = "CESSNA162"
          CORN                = "CORN"
          A320                = "A320"
          EBOOKS              = "EBOOKS"
          EGAMES              = "EGAMES"
          ESPORTS             = "ESPORTS"
          DB                  = "DB"
          R3                  = "R3"
          RICE                = "RICE"
          A330                = "A330"


          DIMENSION_PREFIXES = {
              :revenue => "DIM_DEV_"
          }

          DIMENSION_TREES = {
            :revenue => {
              # Revneue Groups
              GOODS       => ALL,
              ELECTRONICS => ALL,
              SERVICE     => ALL,
              # Products or Services
              A380        => GOODS,
              CPLUSPLUS   => SERVICE,
              BEANS       => GOODS,
              PEELER      => GOODS,
              ASPIRINC    => GOODS,
              CESSNA162   => GOODS,
              CORN        => GOODS,
              A320        => GOODS,
              EBOOKS      => ELECTRONICS,
              EGAMES      => ELECTRONICS,
              ESPORTS     => ELECTRONICS,
              DB          => SERVICE,
              R3          => SERVICE,
              RICE        => GOODS,
              A330        => GOODS
            }
          }

          def path(dimension, leaf, return_hsh = false, reversed = false)
            get_path(DIMENSION_TREES[dimension.to_sym], leaf, DIMENSION_PREFIXES[dimension.to_sym], return_hsh, reversed)
          end

          def save!
            do_save!(self)
          end
        end

        DIMENSION_CLASS = {
            :location       => GeographicDimension,
            :revenue        => RevenueDimension,
            :devision       => BusinessDevisionDimension
        }

        BERLIN_A380_JETPLANES                 = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::BERLIN}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::A380}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::JETPLANES}]}
        ]
        BERLIN_A380_JETPLANES_AMOUNT          = 10
        BERLIN_CPLUSPLUS_DEV_M                = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::BERLIN}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::CPLUSPLUS}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::DEV_M}]}
        ]
        BERLIN_CPLUSPLUS_DEV_M_AMOUNT         = 8

        HAMBURG_BEANS_BIO                     = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::HAMBURG}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::BEANS}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::BIO}]}
        ]
        HAMBURG_BEANS_BIO_AMOUNT              = 3

        TAIPEH_BEANS_GEN                      = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::TAIPEH}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::BEANS}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::GEN}]}
        ]
        TAIPEH_BEANS_GEN_AMOUNT               = 7

        CANBERRA_PEELER_COSMETICS             = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::CANBERRA}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::PEELER}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::COSMETICS}]}
        ]
        CANBERRA_PEELER_COSMETICS_AMOUNT      = 14

        COLOMBO_ASPIRINC_DRUGS                = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::COLOMBO}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::ASPIRINC}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::DRUGS}]}
        ]
        COLOMBO_ASPIRINC_DRUGS_AMOUNT         = 13

        GUANGZHOU_CESSNA162_PROPELLERPLANE    = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::GUANGZHOU}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::CESSNA162}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::PROPELLORPLANES}]}
        ]
        GUANGZHOU_CESSNA162_PROPELLERPLANE_AMOUNT = 2

        CA_CORN_GEN                           = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::CALIFORNIA}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::CORN}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::GEN}]}
        ]
        CA_CORN_GEN_AMOUNT                    = 1

        HAMBURG_A320_JETPLANES                = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::HAMBURG}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::A320}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::JETPLANES}]}
        ]
        HAMBURG_A320_JETPLANES_AMOUNT         = 23

        SHANGHAI_EBOOKS_UP1                   = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::SHANGHAI}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::EBOOKS}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::UP1}]}
        ]
        SHANGHAI_EBOOKS_UP1_AMOUNT            = 2

        NY_EGAMES_UP2                         = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::NEWYORK}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::EGAMES}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::UP2}]}
        ]
        NY_EGAMES_UP2_AMOUNT                  = 7

        NJ_ESPORTS_OTHER1                     = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::NEYJERSEY}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::ESPORTS}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::OTHER1}]}
        ]
        NJ_ESPORTS_OTHER1_AMOUNT              = 9

        FR3_DB_DEV_O                          = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::FR3}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::DB}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::DEV_O}]}
        ]
        FR3_DB_DEV_O_AMOUNT                   = 11

        LONDON_R3_MAINTENANCE_O               = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::LONDON}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::R3}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::MAINTENANCE_O}]}
        ]
        LONDON_R3_MAINTENANCE_O_AMOUNT        = 21

        MANCHASTER_DB_LICENSES_O              = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::MANCHASTER}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::DB}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::LICENSES_O}]}
        ]
        MANCHASTER_DB_LICENSES_O_AMOUNT       = 12

        LIVERPOOL_R3_DEV_S                    = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::LIVERPOOL}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::R3}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::DEV_S}]}
        ]
        LIVERPOOL_R3_DEV_S_AMOUNT             = 9

        CA_R3_MAINTENANCE_S                   = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::CALIFORNIA}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::R3}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::MAINTENANCE_S}]}

        ]
        CA_R3_MAINTENANCE_S_AMOUNT            = 3

        NY_CPLUSPLUS_LICENSES_S               = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::NEWYORK}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::CPLUSPLUS}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::LICENSES_S}]}
        ]
        NY_CPLUSPLUS_LICENSES_S_AMOUNT        = 4

        BAYERN_DB_MAINTENANCE_M               = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::BAYERN}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::DB}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::MAINTENANCE_M}]}
        ]
        BAYERN_DB_MAINTENANCE_M_AMOUNT        = 2

        FR2_CPLUSPLUS_LICENSES_M              = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::FR2}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::CPLUSPLUS}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::LICENSES_M}]}
        ]
        FR2_CPLUSPLUS_LICENSES_M_AMOUNT       = 2

        CARACAS_RICE_BIO                      = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::CARACAS}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::RICE}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::BIO}]}
        ]
        CARACAS_RICE_BIO_AMOUNT               = 4

        JOHANNISBURG_A330_UP4                 = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::JOHANNISBURG}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::A330}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::UP4}]}
        ]
        JOHANNISBURG_A330_UP4_AMOUNT          = 12

        SHANGHAI_R3_UP5                       = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::SHANGHAI}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::R3}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::UP5}]}
        ]
        SHANGHAI_R3_UP5_AMOUNT                = 13

        BEJING_EGAMES_UP6                     = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::BEJING}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::EGAMES}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::UP6}]}
        ]
        BEJING_EGAMES_UP6_AMOUNT              = 4

        COLOMBO_ESPORTS_OTHER2                = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::COLOMBO}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::ESPORTS}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::OTHER2}]}
        ]
        COLOMBO_ESPORTS_OTHER2_AMOUNT         = 5

        MEXICOCITY_EGAMES_JETPLANES           = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::MEXICOCITY}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::EGAMES}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::JETPLANES}]}
        ]
        MEXICOCITY_EGAMES_JETPLANES_AMOUNT    = 9

        OTTOWA_RICE_GEN                       = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::OTTOWA}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::RICE}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::GEN}]}
        ]
        OTTOWA_RICE_GEN_AMOUNT                = 8

        LIVERPOOL_ASPIRINC_BIO                = [
            {:class => GeographicDimension,         :options => [{:dimension => :location,      :value => GeographicDimension::LIVERPOOL}]},
            {:class => RevenueDimension,            :options => [{:dimension => :revenue,       :value => RevenueDimension::ASPIRINC}]},
            {:class => BusinessDevisionDimension,   :options => [{:dimension => :devision,      :value => BusinessDevisionDimension::BIO}]}
        ]
        LIVERPOOL_ASPIRINC_BIO_AMOUNT         = 7


        WORLD_WIDE_BUSINESS = [
          {:line_item => BERLIN_A380_JETPLANES,                     :amount => BERLIN_A380_JETPLANES_AMOUNT},
          {:line_item => BERLIN_CPLUSPLUS_DEV_M,                    :amount => BERLIN_CPLUSPLUS_DEV_M_AMOUNT},
          {:line_item => HAMBURG_BEANS_BIO,                         :amount => HAMBURG_BEANS_BIO_AMOUNT},
          {:line_item => TAIPEH_BEANS_GEN,                          :amount => TAIPEH_BEANS_GEN_AMOUNT},
          {:line_item => CANBERRA_PEELER_COSMETICS,                 :amount => CANBERRA_PEELER_COSMETICS_AMOUNT},
          {:line_item => COLOMBO_ASPIRINC_DRUGS,                    :amount => COLOMBO_ASPIRINC_DRUGS_AMOUNT},
          {:line_item => GUANGZHOU_CESSNA162_PROPELLERPLANE,        :amount => GUANGZHOU_CESSNA162_PROPELLERPLANE_AMOUNT},
          {:line_item => CA_CORN_GEN,                               :amount => CA_CORN_GEN_AMOUNT},
          {:line_item => HAMBURG_A320_JETPLANES,                    :amount => HAMBURG_A320_JETPLANES_AMOUNT},
          {:line_item => SHANGHAI_EBOOKS_UP1,                       :amount => SHANGHAI_EBOOKS_UP1_AMOUNT},
          {:line_item => NY_EGAMES_UP2,                             :amount => NY_EGAMES_UP2_AMOUNT},
          {:line_item => NJ_ESPORTS_OTHER1,                         :amount => NJ_ESPORTS_OTHER1_AMOUNT},
          {:line_item => FR3_DB_DEV_O,                              :amount => FR3_DB_DEV_O_AMOUNT},
          {:line_item => LONDON_R3_MAINTENANCE_O,                   :amount => LONDON_R3_MAINTENANCE_O_AMOUNT},
          {:line_item => MANCHASTER_DB_LICENSES_O,                  :amount => MANCHASTER_DB_LICENSES_O_AMOUNT},
          {:line_item => LIVERPOOL_R3_DEV_S,                        :amount => LIVERPOOL_R3_DEV_S_AMOUNT},
          {:line_item => CA_R3_MAINTENANCE_S,                       :amount => CA_R3_MAINTENANCE_S_AMOUNT},
          {:line_item => NY_CPLUSPLUS_LICENSES_S,                   :amount => NY_CPLUSPLUS_LICENSES_S_AMOUNT},
          {:line_item => BAYERN_DB_MAINTENANCE_M,                   :amount => BAYERN_DB_MAINTENANCE_M_AMOUNT},
          {:line_item => FR2_CPLUSPLUS_LICENSES_M,                  :amount => FR2_CPLUSPLUS_LICENSES_M_AMOUNT},
          {:line_item => CARACAS_RICE_BIO,                          :amount => CARACAS_RICE_BIO_AMOUNT},
          {:line_item => JOHANNISBURG_A330_UP4,                     :amount => JOHANNISBURG_A330_UP4_AMOUNT},
          {:line_item => SHANGHAI_R3_UP5,                           :amount => SHANGHAI_R3_UP5_AMOUNT},
          {:line_item => BEJING_EGAMES_UP6,                         :amount => BEJING_EGAMES_UP6_AMOUNT},
          {:line_item => COLOMBO_ESPORTS_OTHER2,                    :amount => COLOMBO_ESPORTS_OTHER2_AMOUNT},
          {:line_item => MEXICOCITY_EGAMES_JETPLANES,               :amount => MEXICOCITY_EGAMES_JETPLANES_AMOUNT},
          {:line_item => OTTOWA_RICE_GEN,                           :amount => OTTOWA_RICE_GEN_AMOUNT},
          {:line_item => LIVERPOOL_ASPIRINC_BIO,                    :amount => LIVERPOOL_ASPIRINC_BIO_AMOUNT}
        ]

        # ========================= WEB PARAMETER =============================================================
        ACTION_NAME_WORLD_WIDE_BUSINESS               =     "world_wide_business"
        VIEW_LOC_DIM0                                 =     "world_wide_business_loc_dim0"
        VIEW_LOC_DIM1                                 =     "world_wide_business_loc_dim1"
        VIEW_LOC_DIM2                                 =     "world_wide_business_loc_dim2"
        VIEW_LOC_DIM3                                 =     "world_wide_business_loc_dim3"

        PARAMS_WORLD_WIDE_BUSINESS =
        {
          'v_action'                            =>  'world_wide_business',
          'v_controller'                        =>  'dashboard'
        }

        PARAMS_WORLD_WIDE_BUSINESS_WITH_MAP_EMIT_KEYS =
        {
          'v_action'                                                        =>  'world_wide_business',
          'v_controller'                                                    =>  'dashboard',
          "m_" + GeographicDimension::DIMENSION_PREFIXES[:location] + "3"   =>  1,
          "m_" + GeographicDimension::DIMENSION_PREFIXES[:location] + "2"   =>  2
        }

        # dimension (;location, :revenue, :devision, ...)
        # within dimension key for aggregation
        def self.different_values_for_mr(dimension = DIMENSION_CLASS.to_a.collect(&:first), line_items = WORLD_WIDE_BUSINESS)
          values_per_dim = {}

          line_items.each do |item|
            hsh = expanded_line_item_hsh(item[:line_item])
            values_per_dim = values_per_dimension(hsh, values_per_dim)
          end

          return values_per_dim
        end

        def self.values_per_dimension(expanded_line_item, values_per_dim)
          expanded_line_item.each_pair do |dimension, value|
            if values_per_dim[dimension].present?
              values_per_dim[dimension] = (values_per_dim[dimension] << value).uniq
            else
              values_per_dim[dimension] = [value]
            end
          end
          return values_per_dim
        end

        def self.line_items_with_same_value_in_dimension(value, dimension, line_items = WORLD_WIDE_BUSINESS)
          if value.is_a?(Hash)
            raise Exception.new("Currently only one emit key supported!") if value.size > 1
            value = value.values.first.upcase
          elsif value.is_a?(String)
            value = value
          end

          dimension = dimension.downcase.to_sym
          amount = 0

          line_items.each do |item|
            hsh = expanded_line_item_hsh(item[:line_item], DIMENSION_CLASS[dimension])
            amount += item[:amount] if hsh.value?(value)
          end
          return amount
        end

        def self.expanded_line_item_hsh(line_item, dimension = nil)
          hsh = {}

          line_item.each do |line_item_part|
            if( dimension.nil? || line_item_part[:class].eql?(dimension))
              hsh = hsh.merge(line_item_part[:class].new(line_item_part[:options]).to_hash)
            end
          end

          return hsh
        end
      end
    end
  end
end