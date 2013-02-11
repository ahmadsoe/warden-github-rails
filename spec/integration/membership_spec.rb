require 'spec_helper'

describe 'request to a protected resource' do
  context 'that requires a team membership' do
    subject { get '/team/protected' }

    context 'when not logged in' do
      it { should be_github_oauth_redirect }
    end

    context 'when logged in' do
      context 'and team member' do
        before do
          user = github_login
          user.stub_membership(:team => 123)
        end

        it { should be_ok }
      end

      context 'and not team member' do
        before { github_login }
        it { should be_not_found}
      end
    end
  end

  context 'that requires an organization membership' do
    { :org => :foobar_inc, :organization => 'some_org' }.each do |key, value|
      context "which is specified as #{key}" do
        subject { get "/#{key}/protected" }

        context 'when not logged in' do
          it { should be_github_oauth_redirect }
        end

        context 'when logged in' do
          context 'and organization member' do
            before do
              user = github_login
              user.stub_membership(:org => value)
            end

            it { should be_ok }
          end

          context 'and not organization member' do
            before { github_login }
            it { should be_not_found }
          end
        end
      end
    end
  end
end