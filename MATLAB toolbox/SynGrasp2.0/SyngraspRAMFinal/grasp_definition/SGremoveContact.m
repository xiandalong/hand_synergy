function [new_hand] = SGremoveContact(hand,finger,link,alpha)

new_hand = hand;
index = 0;
nc = size(hand.cp,2);
for i=1:nc
    if(hand.cp(4,i) == finger && hand.cp(5,i) == link && hand.cp(6,i) == alpha)
    index = i;
    end
end

new_hand.cp = [hand.cp(:,1:index-1) hand.cp(:,index+1:nc)];
newHand.Jtilde = SGjacobianMatrix(hand);

