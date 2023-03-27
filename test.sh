#!/bin/bash -l

#SBATCH --job-name=testJob		# Name for your job
#SBATCH --comment="Testing Job"		# Comment for your job

#SBATCH --account=rc-help		# Project account to run your job under
#SBATCH --partition=debug		# Partition to run your job on

#SBATCH --output=%x_%j.out		# Output file
#SBATCH --error=%x_%j.err		# Error file

#SBATCH --mail-user=abc1234@rit.edu	# Email address to notify
#SBATCH --mail-type=END			# Type of notification emails to send

#SBATCH --time=0-00:05:00		# Time limit
#SBATCH --nodes=1			# How many nodes to run on
#SBATCH --ntasks=2			# How many tasks per node
#SBATCH --cpus-per-task=2		# Number of CPUs per task
#SBATCH --mem-per-cpu=10g		# Memory per CPU

hostname				# Run the command hostname