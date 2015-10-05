require 'rails_helper'

describe Category, type: :model do
  let(:admin) { FactoryGirl.create(:admin) }
  let!(:graph) { Graph.create(title: 'Sweet new graph') }

  context 'validations' do
    it 'should require titles to be unique' do
      graph2 = Graph.new(title: 'Sweet new graph')
      expect(graph2.valid?).to eq false
    end
  end

  context 'lines' do
    let!(:data_line) { graph.lines.create(title: 'Data')}
    let!(:goal_line) { graph.lines.create(title: 'Goal')}
    it 'should be able to have many lines' do
      expect(graph.lines.count).to eq 4
    end
  end

  context 'creation' do
    # This is just to get the thing out the door we want to initialize
    # a graph with 2 lines.  One called goal and another called data.
    # Eventually want to add as many lines as desired in the ux.

    it 'should start with 2 lines' do
      new_graph = Graph.create(title: 'new_graph')
      expect(new_graph.lines.pluck(:title)).to match_array ['Goal', 'Data']
    end
  end

  context 'data' do
    # create a goal line with 3 values and dates
    # and a data line with 2 values and dates
    before do
      line_goal.points = [goal_point1, goal_point2, goal_point3]
      line_data.points = [data_point2, data_point1]
      graph.lines = [line_goal, line_data]
    end

    let(:goal_point3) { Point.create(time: Date.new(2015, 1, 3), value: 3) }
    let(:goal_point2) { Point.create(time: Date.new(2015, 1, 2), value: 2) }
    let(:goal_point1) { Point.create(time: Date.new(2015, 1, 1), value: 1) }
    let(:data_point1) { Point.create(time: Date.new(2015, 1, 1), value: 2) }
    let(:data_point2) { Point.create(time: Date.new(2015, 1, 2), value: 0) }

    let(:line_goal) { Line.create(title: 'Goal') }
    let(:line_data) { Line.create(title: 'Data') }
    let(:graph) { Graph.create(title: 'Text Graph', unit: 'Calls') }

    it 'should know its data' do
      expect(graph.data).to eq(
        {
          'Goal' => {
            times: [goal_point1.time, goal_point2.time, goal_point3.time],
            values: [goal_point1.value, goal_point2.value, goal_point3.value],
            unit: 'Calls'
          },
          'Data' => {
            times: [data_point1.time, data_point2.time],
            values: [data_point1.value, data_point2.value],
            unit: 'Calls'
          }
        })
    end
  end
end