#!/usr/bin/perl

# Sample script for monitoring smartshop prices using munin.

# Copyright (C) 2018 Gabriel Pérez-Cerezo, licensed under CC-0, like
# rest of the smartshop mod

# adjust variable $file to the smartshop_report.txt file in your
# world, adjust %items to the items you want to have graphed.


use strict;
use warnings;
my $file = "/var/games/minetest-server/.minetest/worlds/world/smartshop_report.txt";
my %items = ("ores" => {"gold" => ["default:gold_ingot", "Gold Ingot"],
			"mese" => ["default:mese_crystal", "Mese Crystal"],
			"diamond" => ["default:diamond", "Diamond"],
			"steel" => ["default:steel_ingot", "Steel Ingot"],
			"coal" => ["default:coal_lump", "Coal Lump"],
			"copper" => ["default:copper_ingot", "Copper Ingot"],
			"uranium" => ["technic:uranium_ingot", "Uranium Ingot"],
			"chromium" => ["technic:chromium_ingot", "Chromium Ingot"],
			"lead" => ["technic:lead_ingot", "Lead Ingot"],
			"zinc" => ["technic:zinc_ingot", "Zinc Ingot"],
			"tin" => ["default:tin_ingot", "Tin Ingot"],
			"silver" => ["moreores:silver_ingot", "Silver Ingot"],
		       },
	     "stones" => {"cobble" => ["default:cobble", "Cobblestone"],
			  "sandstone" => ["default:sandstone", "Sandstone"],
			  "desertstone" => ["default:desert_stone", "Desert Stone"],
			  "desertcobble" => ["default:desert_cobble", "Desert Cobble"],
			  "obsidian" => ["default:obsidian", "Obsidian"],
			  "brick" => ["default:brick", "Brick"],
			  "marble" => ["technic:marble", "Marble"],
			  "graninte" => ["technic:granite", "Granite"],
			  "sand" => ["default:sand", "Sand"],
			  "gravel" => ["default:gravel", "Gravel"],
			  "dirt" => ["default:dirt", "Dirt"],
			 },
	     "crops" => {
			 "carrot" => ["farming:carrot", "Carrot"],
			 "tomato" => ["farming:tomato", "Tomato"],
			 "melon" => ["farming:melon_slice", "Melon"],
			 "pumpkin" => ["farming:pumpkin_slice", "Pumpkin"],
			 "wheat" => ["farming:wheat", "Wheat"],
			 "rhubarb" => ["farming:rhubarb", "Rhubarb"],
			 "blueberries" => ["farming:blueberries", "Blueberries"],
			 "corn" => ["farming:corn", "Corn"],
			 "cucumber" => ["farming:cucumber", "Cucumber"],
			 "grapes" => ["farming:grapes", "Grapes"],			 
			},			  
	    );

sub print_legend {
  my $cat = shift;
  print "graph_category minetest\n";
  foreach (keys %{$items{$cat}}) {
    print "$_.label $items{$cat}{$_}[1]\n";    
  }
  print "\n";
}

if ($_ = shift @ARGV and $_ eq "config") {
#  print "config\n";
  ## initialize the graph
  my $k;
  foreach $k(keys %items) {
    print "multigraph $k"."_supply\n";
    print "graph_title $k being sold\n";
    print "graph_vlabel Number of items for sale\n";
    print_legend $k;
    print "multigraph $k"."_price\n";
    print "graph_title $k Prices\n";
    print "graph_vlabel Price in Minegeld\n";
    print_legend $k;
    print "multigraph $k"."_shops\n";
    print "graph_title Number of shops selling $k\n";
    print "graph_vlabel Number of shops selling this item\n";
    print_legend $k;
  }
  exit 0;

}



my @report;

#$file = "smartshop_report.txt";

open my $fh, "<", $file
  or die "could not open $file: $!";
chomp(@report = <$fh>);

close $fh;

sub vals {
  my $cat = shift;
  my $key = shift;
  foreach (keys %{$items{$cat}}) {
    my @s = @{$items{$cat}{$_}};
    print "$_.value $s[$key]\n";
  }
  print "\n";
}

my @price;
foreach (keys %items) {
  # print values for each category
  my %cat = %{$items{$_}};  
  foreach (keys %cat) {
    my $ore = $cat{$_}[0];
    @price = grep(/$ore /, @report);
    #  @price[0] eq "" and 
    if (scalar @price == 0) {
      $price[0] = "invalid 0 0 0";
    }
    my @data = split(/ /, $price[0]);
    shift @data;
    my $pr = shift @data;
    my $nu = shift @data;
    my $f = shift @data;
    #  print $items{$_}[0];
    push  @{$cat{$_}}, $pr, $nu, $f;
    #  print "$_ $items{$_}[2] $items{$_}[3]\n"
  }
  
  print "multigraph $_"."_supply\n";
  vals $_,2;
  print "multigraph $_"."_price\n";
  vals $_,3;
  print "multigraph $_"."_shops\n";
  vals $_,4;
}

